from flask import render_template, flash, redirect, url_for, session, request
from src import app
from src.forms import LoginForm
from app import get_db
from psycopg2.extras import RealDictCursor


@app.route('/')
@app.route('/index')
def index():
    db = get_db()
    cursor = db.cursor(cursor_factory=RealDictCursor)
    cursor.execute(open('src/sql/recent_updates.sql').read())
    updates = cursor.fetchall()
    return render_template('index.html', updates=updates, corkboards=[])


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
            session.logged_in_user = user
            return redirect(url_for('index'))
    return render_template('login.html', form=login_form)


@app.route('/logout')
def logout():
    session.pop('logged_in_user', None)
    login_form = LoginForm
    return render_template('login.html', form=login_form)

