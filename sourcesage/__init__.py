import os
from flask import Flask, render_template, jsonify
from flask.ext.sqlalchemy import SQLAlchemy
from flask.ext.socketio import SocketIO
from flask.ext.session import Session
from werkzeug.exceptions import default_exceptions
from werkzeug.exceptions import HTTPException

app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY') or 'ThisIsASecretTokenCanNotGuess'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sourcesage.sqlite'
app.debug = True

# Init database
db = SQLAlchemy(app)

# Init session
app.config['SESSION_TYPE'] = 'sqlalchemy'
Session(app)

# Handle error
def make_json_error(ex):
    error_code = (ex.code if isinstance(ex, HTTPException) else 500)
    response = jsonify(error=str(ex), status_code=error_code)
    response.status_code = error_code 
    return response

# Handle all default HTTP Exceptions    
for code in default_exceptions.iterkeys():
    app.error_handler_spec[None][code] = make_json_error

# Init SocketIO
socketio = SocketIO(app)

# Rendering master page
@app.route('/')
def main():
    return render_template('main.html')

# Register API controllers and WebSocket events
from sourcesage.controllers import bp
app.register_blueprint(bp)