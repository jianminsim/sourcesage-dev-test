from gevent import monkey
monkey.patch_all()

import os
import cgi
from flask import Flask, render_template, request
from flask.ext.socketio import SocketIO


app = Flask(__name__)
app.config['SECRET_KEY'] = os.getenv('SECRET_KEY') or 'ThisIsASecretTokenCanNotGuess'
socketio = SocketIO(app)

@app.route('/')
def main():
    return render_template('main.html')
    
if __name__ == '__main__':
    socketio.run(app, port=5000)