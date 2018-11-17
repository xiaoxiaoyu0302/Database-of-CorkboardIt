from flask import render_template, flash, redirect, url_for, session, request
from src import app
from src.forms import LoginForm, PushpinSearchForm, AddCorkboardForm, AddPushPinForm, PrivateCorkboardForm, CommentForm
from app import get_db
from psycopg2.extras import RealDictCursor
from datetime import datetime
import json


@app.route('/', methods=['GET', 'POST'])
@app.route('/index', methods=['GET', 'POST'])
def index():
    if 'logged_in_user' not in session:
        return redirect(url_for('login'))

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/recent_updates.sql').read().format(email=session['logged_in_user']['email']))
    updates = cursor.fetchall()

    cursor.execute(open('src/sql/owned_corkboards.sql').read().format(email=session['logged_in_user']['email']))
    corkboards = cursor.fetchall()

    search_form = PushpinSearchForm()
    if search_form.validate_on_submit():
        query = search_form.search.data
        return redirect(url_for('search_results', query=query))
    return render_template('index.html', updates=updates, corkboards=corkboards, user=session['logged_in_user'],
                           form=search_form)


@app.route('/login', methods=['GET', 'POST'])
def login():
    login_form = LoginForm()
    if login_form.validate_on_submit():
        db = get_db()
        cursor = db.cursor(cursor_factory=RealDictCursor)
        cursor.execute(open('src/sql/login.sql', 'r').read().format(email=login_form.email.data,
                                                                    pin=login_form.pin.data))
        user = cursor.fetchone()
        if user is None:
            flash("Unable to login. Try again.")
        else:
            session['logged_in_user'] = user
            return redirect(url_for('index'))
    return render_template('login.html', form=login_form)


@app.route('/logout')
def logout():
    session.pop('logged_in_user', None)
    return redirect(url_for('login'))


def get_category_choices():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/get_categories.sql').read())
    return cursor.fetchall()


@app.route('/add_corkboard', methods=['GET', 'POST'])
def add_corkboard():
    add_form = AddCorkboardForm()

    for option in get_category_choices():
        add_form.category.choices += [(option['category_name'], option['category_name'])]

    if add_form.validate_on_submit():
        db = get_db()
        cursor = db.cursor(cursor_factory=RealDictCursor)
        corkboard_title = add_form.title.data
        escaped_corkboard_title = corkboard_title.replace("'", "''")
        cursor.execute(open('src/sql/add_corkboard.sql', 'r').read().format(title=escaped_corkboard_title,
                                                                            is_private=add_form.is_private.data,
                                                                            password=add_form.password.data,
                                                                            owner=session['logged_in_user']['email'],
                                                                            category=add_form.category.data))
        db.commit()
        return redirect(url_for('index'))
    return render_template('add_corkboard.html', form=add_form)


@app.route('/populartags')
def get_popular_tags():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/popular_tags.sql').read())
    tags = cursor.fetchall()

    return render_template('popular_tags.html', user=session['logged_in_user'], tags=tags)


@app.route('/popularsites')
def get_popular_sites():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/popular_sites.sql').read())
    popular_sites = cursor.fetchall()

    return render_template('popular_sites.html', popular_sites=popular_sites)


@app.route('/corkboard')
def get_corkboard():
    if 'logged_in_user' not in session:
        return redirect(url_for('login'))

    return render_template('corkboard.html', user=session['logged_in_user'])


@app.route('/corkboard/<corkboard_id>', methods=['GET', 'POST'])
def get_corkboard_by_id(corkboard_id):
    if 'logged_in_user' not in session:
        return redirect(url_for('login'))

    form = PrivateCorkboardForm()

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/get_corkboard_by_id.sql').read().format(corkboard_id=corkboard_id))
    corkboard = cursor.fetchone()

    cursor.execute(open('src/sql/get_pushpins_by_corkboard_id.sql').read().format(corkboard_id=corkboard_id))
    pushpins = cursor.fetchall()

    permission = session['logged_in_user']['email'] == corkboard['owner']
    session['current_corkboard_owner'] = corkboard['owner']
    session['current_corkboard'] = corkboard_id
    cursor.execute(open('src/sql/is_watched.sql', 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          corkboard_id=session['current_corkboard']))
    is_watched = cursor.fetchone()['is_watched']

    # cursor.execute(open('src/sql/is_followed.sql', 'r').read().format(user=session['logged_in_user']['email'],
    #                                                                  followed_user=corkboard['owner']))
    # is_followed = cursor.fetchone()['is_followed']

    cursor.execute(open('src/sql/is_followed.sql', 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          followed_user_email=session['current_corkboard_owner']))
    is_followed = cursor.fetchone()['is_followed']

    print("is_private: " + corkboard['is_private'])

    if form.validate_on_submit():
        if form.pin.data != corkboard['password']:
            flash("Unable to login. Try again.")
        else:
            return render_template('corkboard.html', corkboard=corkboard, pushpins= pushpins, permission = permission,
                                  is_watched=is_watched, corkboard_id = corkboard_id, user=session['logged_in_user'])

    if corkboard['is_private'] == '1':
        return render_template('corkboard_private.html', form = form, corkboard=corkboard, pushpins= pushpins, permission = permission,
                               is_watched=is_watched, is_followed=is_followed, corkboard_id = corkboard_id, user=session['logged_in_user'])

    return render_template('corkboard.html', corkboard=corkboard, pushpins= pushpins, permission = permission,
                           is_watched=is_watched, is_followed=is_followed, corkboard_id = corkboard_id, user=session['logged_in_user'])


@app.route('/corkboard/<corkboard_id>/add_pushpin', methods=['GET', 'POST'])
def add_pushpin(corkboard_id):
    add_form = AddPushPinForm()

    if add_form.validate_on_submit():
        db = get_db()
        cursor = db.cursor(cursor_factory=RealDictCursor)
        time_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        pushpin_description = add_form.description.data
        escaped_pushpin_description = pushpin_description.replace("'", "''")
        cursor.execute(open('src/sql/add_pushpin.sql', 'r').read().format(description=escaped_pushpin_description,
                                                                            image_link=add_form.image_link.data,
                                                                            time_added=time_now,
                                                                            corkboard_id=corkboard_id))
        db.commit()
        cursor.execute(open('src/sql/get_pushpin_id_after_commit.sql').read().format(corkboard_id=corkboard_id,
                                                                                     time_added=time_now))
        pushpin_id = cursor.fetchone()['id']
        for tag_text in str(add_form.tags.data).split(','):
            tag_text = tag_text.strip()
            cursor.execute(open('src/sql/add_tag.sql', 'r').read().format(pushpin_id=pushpin_id,
                                                                          tag_text=tag_text))
            db.commit()
        return redirect(url_for('get_corkboard')+'/'+corkboard_id)
    return render_template('add_pushpin.html', corkboard_id=corkboard_id, form=add_form)


@app.route('/watch_corkboard')
def watch_corkboard():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/is_watched.sql', 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          corkboard_id=session['current_corkboard']))
    is_watched = cursor.fetchone()['is_watched']
    if is_watched:
        query = 'src/sql/unwatch_corkboard.sql'
    else:
        query = 'src/sql/watch_corkboard.sql'

    cursor.execute(open(query, 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          corkboard_id=session['current_corkboard']))
    db.commit()
    return redirect(url_for('get_corkboard')+'/'+ session['current_corkboard'])

# @app.route('/follow_user')
# def follow_user():
#     db = get_db()
#     cursor = db.cursor(cursor_factory=RealDictCursor)
#     cursor.execute(open('src/sql/get_corkboard_by_id.sql').read().format(corkboard_id=session['current_corkboard']))
#     corkboard_owner = cursor.fetchone()['owner']
#     cursor.execute(open('src/sql/is_followed.sql', 'r').read().format(user=session['logged_in_user']['email'],
#                                                                           followed_user=corkboard_owner))
#     is_followed = cursor.fetchone()['is_followed']
#     if is_followed:
#         query = 'src/sql/unfollow_user.sql'
#     else:
#         query = 'src/sql/follow_user.sql'

#     cursor.execute(open(query, 'r').read().format(user_email=session['logged_in_user']['email'],
#                                                   followed_user=corkboard_owner))
#     db.commit()
#     return redirect(url_for('get_corkboard')+'/'+ session['current_corkboard'])

@app.route('/follow_user')
def follow_user():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/is_followed.sql', 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          followed_user_email=session['current_corkboard_owner']))
    is_followed = cursor.fetchone()['is_followed']
    if is_followed:
        query = 'src/sql/unfollow_user.sql'
    else:
        query = 'src/sql/follow_user.sql'

    cursor.execute(open(query, 'r').read().format(user_email=session['logged_in_user']['email'],
                                                                          followed_user_email=session['current_corkboard_owner']))
    db.commit()
    return redirect(url_for('get_corkboard')+'/'+ session['current_corkboard'])

@app.route('/search_results')
def search_results():
    query = request.args.get('query')
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/search_pushpins.sql').read().format(query=query))
    results = cursor.fetchall()
    return render_template('search_results.html', query=query,
                        results=results, user=session['logged_in_user'])

@app.route('/corkboard/<corkboard_id>/pushpin/<pushpin_id>', methods=['GET', 'POST'])
def view_pushpin(corkboard_id, pushpin_id):
    if 'logged_in_user' not in session:
        return redirect(url_for('login'))

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/get_corkboard_by_id.sql').read().format(corkboard_id=corkboard_id))
    corkboard = cursor.fetchone()

    cursor.execute(open('src/sql/get_pushpins_by_pushpin_id.sql').read().format(pushpin_id=pushpin_id))
    pushpin = cursor.fetchone()
    pushpin['time_added'] = str(pushpin['time_added'])

    cursor.execute(open('src/sql/get_tags_for_pushpin.sql').read().format(pushpin_id=pushpin_id))
    tag_texts = cursor.fetchall()
    text = ''
    for t in tag_texts:
        text += str(t['tag_text']) + ', '
    tags = text[:-2]

    cursor.execute(open('src/sql/liked_or_unliked.sql').read().format(email=session['logged_in_user']['email'], pushpin_id=pushpin_id))
    liked = True
    if not cursor.fetchone():
        liked = False

    permission = corkboard['owner'] != session['logged_in_user']['email']

    cursor.execute(open('src/sql/get_all_likes.sql').read().format(pushpin_id=pushpin_id))
    likes = cursor.fetchall()

    cursor.execute(open('src/sql/get_comments_by_pushpin_id.sql').read().format(pushpin_id=pushpin_id))
    comments = cursor.fetchall()

    comment_form = CommentForm()
    if comment_form.validate_on_submit():
        time_now = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
        comment_text = comment_form.comment_text.data
        escaped_comment_text = comment_text.replace("'","''")
        user = session['logged_in_user']['email']

        cursor.execute(open('src/sql/add_comment.sql', 'r').read().format(comment_text=escaped_comment_text,
                                                                          user=user,
                                                                          pushpin_id=pushpin_id,
                                                                          time_added=time_now))
        db.commit()

        return redirect(url_for('view_pushpin', corkboard_id=corkboard_id, pushpin_id=pushpin_id))

    return render_template('view_pushpin.html', corkboard=corkboard, pushpin=pushpin, tags = tags,
                           corkboard_id=corkboard_id, liked=liked, user=session['logged_in_user'], permission=permission,
                           likes=likes, comment_form=comment_form, comments=comments)

@app.route('/like_unlike')
def like_unlike_pushpin():
    pushpin_id = request.args.get('pushpin_id')
    corkboard_id = request.args.get('corkboard_id')

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/liked_or_unliked.sql').read().format(email=session['logged_in_user']['email'], pushpin_id=pushpin_id))
    if not cursor.fetchone():
        sql = open('src/sql/like_pushpin.sql').read().format(email=session['logged_in_user']['email'], pushpin_id=pushpin_id)
    else:
        sql = open('src/sql/unlike_pushpin.sql').read().format(email=session['logged_in_user']['email'], pushpin_id=pushpin_id)

    cursor.execute(sql)
    db.commit()
    return redirect(url_for('view_pushpin', corkboard_id=corkboard_id, pushpin_id=pushpin_id))

