import os
from flask import Flask, render_template
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.socketio import SocketIO

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY') or 'ThisIsASecretTokenCanNotGuess'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sourcesage.sqlite'
app.debug = True

db = SQLAlchemy(app)
socketio = SocketIO(app)

@app.route('/')
def main():
    return render_template('main.html')

from sourcesage.controllers import bp
app.register_blueprint(bp)