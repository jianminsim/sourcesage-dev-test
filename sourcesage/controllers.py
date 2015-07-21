from sourcesage import db, socketio, app
from models import Question, User, Answer
from flask import Flask, Blueprint, render_template, request, session, jsonify
import json
import md5

DEFAULT_SELECTED_SIZE = 10
MAX_SELECTED_SIZE = 50

bp = Blueprint('api', __name__, url_prefix='/api')

def hash_md5(value):
	m = md5.new()
	m.update(value)
	return m.hexdigest()

@bp.route('/login', methods=['POST'])
def login():
	data = json.loads(request.data)
	
	email = data['email']
	password = hash_md5(data['password'])
	
	user = User.query.filter(User.email == email).first()
	
	if user and user.password == password:
		session['user_id'] = user.id
		return jsonify({'status': 1})
	
	return jsonify({'status': 0})

@bp.route('/signup', methods=['POST'])
def signup():
	data = json.loads(request.data)
	data['password'] = hash_md5(data['password'])
	user = User(**data)
	result = user.save()
	
	if result:
		session['user_id'] = user.id
	
	return jsonify({'status': 1 if result else 0})
	
@bp.route('/questions', methods=['GET'])
def get_questions():
	offset = int(request.args.get('offset', 0))
	limit = min(int(request.args.get('limit', DEFAULT_SELECTED_SIZE)), MAX_SELECTED_SIZE)
	
	resp = {
		'questions': []
	}
	
	questions = db.session.query(Question, User).join(
        User, Question.author_id == User.id
    ).order_by(Question.id.desc()).limit(limit).offset(offset).all()
	
	if questions:
		for question, user in questions:
			ques = question.to_dict()
			ques['author'] = user.to_dict()
			resp['questions'].append(ques)

	return jsonify(resp)

@bp.route('/questions', methods=['POST'])
def create_question():
	user_id = session['user_id']
	data = json.loads(request.data)
	data['author_id'] = user_id
	
	question = Question(**data)
	result = question.save()
	
	if result:
		ques = question.to_dict()
		author = User.query.get(user_id).to_dict()
		ques['author'] = author
		socketio.emit('newquestion', ques, namespace='/qa')
	
	return jsonify({'status': 1 if result else 0})

@bp.route('/questions/<question_id>', methods=['GET'])
def get_question(question_id):
	question = Question.query.get(question_id).to_dict()
	author = User.query.get(question['author_id']).to_dict()
	question['author'] = author
	question['answers'] = []
	
	answers = db.session.query(Answer, User).join(
        User, Answer.author_id == User.id
    ).filter(Answer.question_id==question_id).order_by(Answer.id.asc()).all()

	if answers:
		for ans, user in answers:
			answ = ans.to_dict()
			answ['author'] = user.to_dict()
			question['answers'].append(answ)
	
	return jsonify(question)

@bp.route('/questions/<question_id>/reply', methods=['POST'])
def reply_question(question_id):
	user_id = session['user_id']
	data = json.loads(request.data)
	data['author_id'] = user_id
	data['question_id'] = question_id
	
	answer = Answer(**data)
	result = answer.save()
	
	if result:
		answer = answer.to_dict()
		author = User.query.get(user_id).to_dict()
		answer['author'] = author
		socketio.emit('question' + str(question_id), answer, namespace='/qa')
	
	return jsonify({'status': 1 if result else 0})
	
@socketio.on('connect', namespace='/qa')
def test_connect():
    print "One client has connected to WebSocket !"


@socketio.on('disconnect', namespace='/qa')
def test_disconnect():
    print "One client has disconnected from WebSocket !"