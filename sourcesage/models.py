from sourcesage import db
import os
import datetime

class Model(db.Model):
    __abstract__ = True

    def save(self):
        try:
            db.session.add(self)
            db.session.commit()
        except Exception, ex:
            print str(ex)
            return False
        return True

    def to_dict(self):
        return dict(
            (k, getattr(self, k)) for k in self.public_fields
        )

    def update(self, data):
        for k, v in data.items():
            if k in self.mutable_fields:
                setattr(self, k, v)
        return self.save()
        
class User(Model):
    __tablename__ = 'users'
    
    public_fields = [
        'id',
        'email'
    ]
    
    mutable_fields = [
        'password'
    ]
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    email = db.Column(db.String(64), unique=True, nullable=False)
    password = db.Column(db.String(32), nullable=False)
    questions = db.relationship('Question', backref='author', lazy='dynamic')

class Question(Model):
    __tablename__ = 'questions'
    
    public_fields = [
        'id',
        'content',
        'author_id',
        'created_time'
    ]
    
    mutable_fields = [
        'content'
    ]
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    content = db.Column(db.String(500), nullable=False)
    author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    created_time = db.Column(db.DateTime, nullable=False, default=datetime.datetime.now)
    answers = db.relationship('Answer', backref='question', lazy='dynamic')

class Answer(Model):
    __tablename__ = 'answers'
    
    public_fields = [
        'id',
        'content',
        'author_id',
        'question_id',
        'created_time'
    ]
    
    mutable_fields = [
        'content'
    ]
    
    id = db.Column(db.Integer, primary_key=True, autoincrement=True)
    content = db.Column(db.String(500), nullable=False)
    author = db.relationship('User', backref='users')
    author_id = db.Column(db.Integer, db.ForeignKey('users.id'))
    question_id = db.Column(db.Integer, db.ForeignKey('questions.id'))
    created_time = db.Column(db.DateTime, nullable=True, default=datetime.datetime.now)

if not os.path.isfile('sourcesage.sqlite'):
    db.create_all()