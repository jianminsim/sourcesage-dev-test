from wtforms import Form, StringField, PasswordField, validators
from models import Users
from app import app
import hashlib


class LoginForm(Form):
    username = StringField('Username', [validators.DataRequired()])
    password = PasswordField('Password', [validators.DataRequired()])

    def __init__(self, *args, **kwargs):
        Form.__init__(self, *args, **kwargs)
        self.user = None

    def validate(self):
        rv = Form.validate(self)
        if not rv:
            return False

        user = Users.query.filter_by(
            username=self.username.data).first()
        if user is None:
            self.username.errors.append('Unknown username')
            return False

        if not self.check_password_hash(user.password, self.password.data):
            self.password.errors.append('Invalid password')
            return False

        self.user = user
        return True

    @staticmethod
    def generate_password_hash(password):
        salted_hash = password + app.config['SECRET_KEY']
        return hashlib.sha224(salted_hash).hexdigest()

    @staticmethod
    def check_password_hash(user_password, given_password):
        if LoginForm.generate_password_hash(given_password) == user_password:
            return True
        else:
            return False

class SignUpForm(Form):
    name = StringField('Full Name', [validators.DataRequired()])
    username = StringField('Username', [validators.DataRequired()])
    password = PasswordField('Password', [validators.DataRequired()])

    def __init__(self, *args, **kwargs):
        Form.__init__(self, *args, **kwargs)
        self.user = None

    def validate(self):
        rv = Form.validate(self)
        if not rv:
            return False

        user = Users.query.filter_by(
            username=self.username.data).first()
        if user:
            self.username.errors.append('Username already exist, Please choose different username')
            return False

        return True