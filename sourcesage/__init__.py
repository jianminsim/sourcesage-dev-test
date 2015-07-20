import os
from flask import Flask, render_template
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.socketio import SocketIO
from flask.ext.session import Session

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY') or 'ThisIsASecretTokenCanNotGuess'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sourcesage.sqlite'
app.debug = True

# Init database
db = SQLAlchemy(app)

# Init session
app.config['SESSION_TYPE'] = 'sqlalchemy'
Session(app)

# Init SocketIO
socketio = SocketIO(app)

# Rendering master page
@app.route('/')
def main():
    return render_template('main.html')

# Register API controllers and WebSocket events
from sourcesage.controllers import bp
app.register_blueprint(bp)