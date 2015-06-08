__author__ = 'ashish'
import datetime
from app import db
from flask.ext.login import UserMixin

class Users(db.Model, UserMixin):
    __tablename__ = 'users'
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(64), nullable=False)
    username = db.Column(db.String(64), unique=True, nullable=False)
    password = db.Column(db.String(64), nullable=False)
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)

class Questions(db.Model):
    __tablename__ = 'questions'
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(500), nullable=False)
    users = db.relationship('Users', backref='questions')
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)

class Answers(db.Model):
    __tablename__ = 'answers'
    id = db.Column(db.Integer, primary_key=True)
    data = db.Column(db.String(500), nullable=False)
    questions = db.relationship('Questions', backref='answers')
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'))
    users = db.relationship('Users', backref='answerss')
    user_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)


db.create_all()
