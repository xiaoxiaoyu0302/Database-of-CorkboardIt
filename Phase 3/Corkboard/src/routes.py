from flask import render_template
from src import app

@app.route('/')
@app.route('/index')
def index():
    title = 'Title test'
    posts = [
        { 'author': 'Austin', 'body': 'Body test' },
        { 'author': 'Jon', 'body': 'Another post' }
    ]
    return render_template('index.html', title=title, posts=posts)


@app.route('/login')
def login():
    return "Login"
