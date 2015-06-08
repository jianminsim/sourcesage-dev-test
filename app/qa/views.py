from app import db, socketio, app, login_manager
from flask.ext.socketio import SocketIO, emit, send
from flask_login import login_user, logout_user, current_user
from flask_login import login_required
from collections import OrderedDict
from models import Questions, Users, Answers
from flask import Flask, Blueprint, render_template, request, session, redirect, url_for
from forms import LoginForm, SignUpForm

mod = Blueprint('qa', __name__, url_prefix='/qa')

login_manager.login_view = 'qa.login'

@login_manager.user_loader
def get_user(ident):
  return Users.query.get(int(ident))

@mod.route('/')
@login_required
def home():
    data_dic = {}
    temp_data={}
    questions = Questions.query.all()
    answers = Answers.query.all()
    for question in questions:
        data_dic[(question.id, question.data, question.users.name)]=[]
        temp_data[question.id] = (question.data, question.users.name)
    for answer in answers:
        data_dic[(answer.question_id, temp_data[answer.question_id][0], \
                  temp_data[answer.question_id][1])].append((answer.data, answer.users.name))
    data_dic = OrderedDict(sorted(data_dic.iteritems(),key=lambda x: x[0][0]))
    return render_template('index.html', data_dic=data_dic, user=current_user)


@mod.route('/login', methods=['GET', 'POST'])
def login():
    """For GET requests, display the login form. For POSTS, login the current user
    by processing the form."""
    form = LoginForm(request.form)
    if request.method == "POST" and form.validate():
        user = form.user
        user.authenticated = True
        db.session.add(user)
        db.session.commit()
        login_user(user, remember=True)
        return redirect(url_for("qa.home"))
    return render_template("login.html", form=form)

@mod.route('/logout')
@login_required
def logout():
    """Logout the current user."""
    user = current_user
    user.authenticated = False
    db.session.add(user)
    db.session.commit()
    logout_user()
    return redirect(url_for('qa.login'))

@mod.route('/sign_up', methods=['GET','POST'])
def sign_up():
    form = SignUpForm(request.form)
    if request.method == "POST" and form.validate():
        password = LoginForm.generate_password_hash(form.password.data)
        user = Users(username=form.username.data, password=password, name=form.name.data)
        try:
            user.authenticated = True
            db.session.add(user)
            db.session.commit()
            login_user(user,remember=True)
        except Exception, ex:
            print str(ex)
            return {'stat' : 'fail', 'error' : str(ex)}
        else:
            return redirect(url_for("qa.home"))
    return render_template("sign_up.html", form=form)


@socketio.on('my question')
def handle_my_custom_event(data):
    """
    If somebody post a question then it will handled here

    """
    question_text = data.get('data','')
    if question_text:
        question_obj = Questions(data=question_text, user_id=current_user.id)
        try:
            db.session.add(question_obj)
            db.session.commit()
            emit('my question', {"data":data.get('data',''), "count":question_obj.id, "user_name": current_user.name}, broadcast=True)
        except Exception, ex:
            print "Exception:", str(ex)

@socketio.on('my response')
def handle_my_custom_event(data):
    """
    If somebody respond to a question then it here will be handled here

    """
    question_id = data.get('q_id','')
    answer_text = data.get('data','')
    if question_id and answer_text:
        answer_obj = Answers(data=answer_text, question_id=question_id, user_id=current_user.id)
        try:
            db.session.add(answer_obj)
            db.session.commit()
            data.update({"user_name" : current_user.name})
            emit('my response', data, broadcast=True)
        except Exception, ex:
            print "Exception:", str(ex)

@socketio.on('connected')
def handle_my_custom_event(data):
    pass
