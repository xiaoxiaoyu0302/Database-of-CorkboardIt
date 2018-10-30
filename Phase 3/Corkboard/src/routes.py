from flask import render_template, flash, redirect, url_for
from src import app
from src.forms import LoginForm


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
        flash('Login requested for user {}'.format(login_form.username.data))
        return redirect(url_for('index'))
    return render_template('login.html', form=login_form)
