from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, RadioField, PasswordField
from wtforms.validators import DataRequired


class LoginForm(FlaskForm):
    email = StringField('E-Mail Address', validators=[DataRequired()])
    pin = PasswordField('PIN', validators=[DataRequired()])
    submit = SubmitField('Login')

class AddCorkboardForm(FlaskForm):
    title = StringField('Title', validators=[DataRequired()])
    #category = SelectField()
    is_private = RadioField('Visibility', choices=[('0', 'public'), ('1','private')])
    password = PasswordField('Password')
    submit = SubmitField('Add Corkboard')

class PushpinSearchForm(FlaskForm):
    search = StringField('Search', validators=[DataRequired()])
    submit = SubmitField('Search Pushpins')
