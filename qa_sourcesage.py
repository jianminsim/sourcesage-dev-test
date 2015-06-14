from flask import Flask, render_template
from flask.ext.socketio import SocketIO, emit, send
from flaskext.mysql import MySQL
from flask.ext.sqlalchemy import SQLAlchemy
from collections import OrderedDict
import datetime

app = Flask(__name__)
app.config['SECRET_KEY'] = '23748273498724babdgadhs384983457'
socketio = SocketIO(app)

#app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://ashish:abc123@localhost/sourcesage_db'
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sourcesage.sqlite'
app.debug = True

db = SQLAlchemy(app)

class User(db.Model):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), nullable=True)
    email = db.Column(db.String(64), nullable=True)

class Questions(db.Model):
    __tablename__ = 'questions'
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(500), nullable=False)
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)

class Answers(db.Model):
    __tablename__ = 'answers'
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(500), nullable=False)
    questions = db.relationship('Questions', backref='questions')
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'))
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)

db.create_all()

@app.route('/')
def home():
    data_dic = {}
    temp_data={}
    questions = Questions.query.all()
    answers = Answers.query.all()
    for question in questions:
        data_dic[(question.id, question.data)]=[]
	temp_data[question.id] = question.data
    for answer in answers:
	data_dic[(answer.question_id, temp_data[answer.question_id])].append(answer.data)
    data_dic = OrderedDict(sorted(data_dic.iteritems(),key=lambda x: x[0][0]))
    return render_template('index.html', data_dic=data_dic)

@socketio.on('my question')
def handle_my_custom_event(data):
    question_text = data.get('data','')
    if question_text:
        question_obj = Questions(data=question_text)
    	try:
	    db.session.add(question_obj)
            db.session.commit()
            emit('my question', {"data":data.get('data',''), "count":question_obj.id}, broadcast=True)
        except Exception, ex:
	    print "Exception:", str(ex)

@socketio.on('my response')
def handle_my_custom_event(data):
    question_id = data.get('q_id','')
    answer_text = data.get('data','')
    if question_id and answer_text:
        answer_obj = Answers(data=answer_text, question_id=question_id)
        try:
	    db.session.add(answer_obj)
            db.session.commit()
            emit('my response', data, broadcast=True)
        except Exception, ex:
            print "Exception:", str(ex)

@socketio.on('connected')
def handle_my_custom_event(data):
    pass



if __name__ == '__main__':
    socketio.run(app)
