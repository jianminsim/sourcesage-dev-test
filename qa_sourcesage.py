from flask import Flask, render_template
from flask.ext.socketio import SocketIO, emit, send

app = Flask(__name__)
app.config['SECRET_KEY'] = 'secret!'
socketio = SocketIO(app)

app.debug = True

question_id=0

@app.route('/')
def home():
    return render_template('index.html')

@socketio.on('message')
def handle_message(message):
    print('received message: ' + message)

@socketio.on('my question')
def handle_my_custom_event(data):
    print('received question: ' + data.get('data'))
    print "Got count", data.get('count','')
    global question_id
    question_id+=1; 
    emit('my question', {"data":data.get('data',''), "count":question_id}, broadcast=True)

@socketio.on('my response')
def handle_my_custom_event(data):
    print('received response: ' + str(data))
    emit('my response', data, broadcast=True)

@socketio.on('connected')
def handle_my_custom_event(data):
    print('Received Connected: ' + str(data))



if __name__ == '__main__':
    socketio.run(app)
