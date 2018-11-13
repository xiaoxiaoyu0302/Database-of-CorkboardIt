from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, SubmitField, SelectField, RadioField
from wtforms.validators import DataRequired

class LoginForm(FlaskForm):
    email = StringField('E-Mail Address', validators=[DataRequired()])
    pin = PasswordField('PIN', validators=[DataRequired()])
    submit = SubmitField('Login')

class AddCorkboardForm(FlaskForm):
    title = StringField('Title', validators=[DataRequired()])
    category = SelectField('Category', choices=[])
    is_private = RadioField('Visibility', choices=[('0', 'Public'), ('1','Private')], validators=[DataRequired()])
    password = StringField('Password')
    submit = SubmitField('Add Corkboard')

class PushpinSearchForm(FlaskForm):
    search = StringField('Search', validators=[DataRequired()], render_kw={"placeholder": "Search..."})
    submit = SubmitField('Search Pushpins')

class AddPushPinForm(FlaskForm):
    description = StringField('Description', validators=[DataRequired()])
    image_link = StringField('Image link', validators=[DataRequired()])
    tags = StringField('Tags', validators=[DataRequired()])
    submit = SubmitField('Add Pushpin')

class WatchForm(FlaskForm):
    submit = SubmitField()