from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField
from wtforms.validators import DataRequired


class LoginForm(FlaskForm):
    email = StringField('E-Mail Address', validators=[DataRequired()])
    pin = PasswordField('PIN', validators=[DataRequired()])
    submit = SubmitField('Login')


class PushpinSearchForm(FlaskForm):
    search = StringField('Search', validators=[DataRequired()])
    submit = SubmitField('Search Pushpins')
