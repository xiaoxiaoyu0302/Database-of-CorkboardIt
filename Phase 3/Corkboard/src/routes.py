from flask import render_template, flash, redirect, url_for, g
from src import app
from src.forms import LoginForm
from app import get_db


@app.route('/')
@app.route('/index')
def index():
    title = 'Title test'
    posts = [
        { 'author': 'Austin', 'body': 'Body test' },
        { 'author': 'Jon', 'body': 'Another post' }
    ]
    return render_template('index.html', title=title, posts=posts)


@app.route('/login', methods=['GET', 'POST'])
def login():
    login_form = LoginForm()
    if login_form.validate_on_submit():
        db = get_db()
        cursor = db.cursor()
        cursor.execute(open('src/sql/login.sql', 'r').read().format(email=login_form.email.data,
                                                                    pin=login_form.pin.data))
        if len(cursor.fetchone()) == 0:
            flash("Unable to login. Try again.")
        else:
            flash("Login successful.")
        return redirect(url_for('index'))
    return render_template('login.html', form=login_form)
