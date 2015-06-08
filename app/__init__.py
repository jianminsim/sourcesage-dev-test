__author__ = 'ashish'

from flask import Flask
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.socketio import SocketIO
from flask.ext.login import LoginManager
from werkzeug.routing import Rule

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sourcesage.sqlite'
app.config['SECRET_KEY'] = '23748273498724babdgadhs384983457'
app.debug = True

app.url_map.add(Rule('/', endpoint='qa.home'))
app.url_map.add(Rule('/login', endpoint='qa.login'))
app.url_map.add(Rule('/logout', endpoint='qa.logout'))
app.url_map.add(Rule('/sign_up', endpoint='qa.sign_up'))

login_manager = LoginManager()
login_manager.init_app(app)

db = SQLAlchemy(app)
socketio = SocketIO(app)

from app.qa.views import mod as qaModule
app.register_blueprint(qaModule)





