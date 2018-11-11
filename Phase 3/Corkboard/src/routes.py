from flask import render_template, flash, redirect, url_for, session
from src import app
from src.forms import LoginForm, PushpinSearchForm, AddCorkboardForm, AddPushPinForm
from app import get_db
from psycopg2.extras import RealDictCursor
from datetime import datetime



@app.route('/')
@app.route('/index', methods=['GET', 'POST'])
def index():
    if 'logged_in_user' not in session:
        return redirect(url_for('login'))

    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/recent_updates.sql').read())
    updates = cursor.fetchall()

    cursor.execute(open('src/sql/owned_corkboards.sql').read().format(email=session['logged_in_user']['email']))
    corkboards = cursor.fetchall()

    search_form = PushpinSearchForm()
    if search_form.validate_on_submit():
        flash(search_form.search.data)
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
        cursor.execute(open('src/sql/add_corkboard.sql', 'r').read().format(title=add_form.title.data,
                                                                            is_private=add_form.is_private.data,
                                                                            password=add_form.password.data,
                                                                            owner=session['logged_in_user']['email'],
                                                                            category=add_form.category.data))
        db.commit()
        return redirect(url_for('index'))
    return render_template('add_corkboard.html', form=add_form)


@app.route('/populartags')
def get_popular_tags():
    return render_template('popular_tags.html', user=session['logged_in_user'])

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
    
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)

    cursor.execute(open('src/sql/get_corkboard_by_id.sql').read().format(corkboard_id=corkboard_id))
    corkboard = cursor.fetchone()
    
    cursor.execute(open('src/sql/get_pushpins_by_corkboard_id.sql').read().format(corkboard_id=corkboard_id))
    pushpins = cursor.fetchall()
    
    permission = session['logged_in_user']['email'] == corkboard['owner']
    
    print(permission)
    
    return render_template('corkboard.html', corkboard=corkboard, pushpins= pushpins, permission = permission,
                            corkboard_id = corkboard_id, user=session['logged_in_user'])
    
@app.route('/corkboard/<corkboard_id>/add_pushpin', methods=['GET', 'POST'])
def add_pushpin(corkboard_id):
    add_form = AddPushPinForm()

    if add_form.validate_on_submit():
        db = get_db()
        cursor = db.cursor(cursor_factory=RealDictCursor)
        cursor.execute(open('src/sql/add_pushpin.sql', 'r').read().format(description=add_form.description.data,
                                                                            image_link=add_form.image_link.data,
                                                                            time_added=datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                                                                            corkboard_id=corkboard_id))
        db.commit()
        return redirect(url_for('get_corkboard')+'/'+corkboard_id)
    return render_template('add_pushpin.html', corkboard_id=corkboard_id, form=add_form)
