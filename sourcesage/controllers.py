from sourcesage import db, socketio, app
from models import Question, User, Answer
from flask import Flask, Blueprint, render_template, request, session, jsonify
import json
import md5

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
	
	return jsonify({'status': 1 if result else 0})