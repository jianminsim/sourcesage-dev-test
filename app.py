import sqlite3
from contextlib import closing
from flask import Flask, render_template, g, Response, request,json

#config
DATABASE = 'db/app.db'
DEBUG = False
SECRET_KEY = 'hellothisisanewapp'
USERNAME = 'admin'
PASSWORD = 'default'

app = Flask(__name__)
app.config.from_object(__name__)

#database methods
def connect_db():
	return sqlite3.connect(app.config['DATABASE'])

def init_db():
	with closing(connect_db()) as db:
		with app.open_resource('schema.sql', mode='r') as f:
			db.cursor().executescript(f.read())
		db.commit()

@app.before_request
def before_request():
	g.db = connect_db()

@app.teardown_request
def teardown_request(exception):
	db = getattr(g, 'db', None)
	if db is not None:
		db.close()

#View functions:
@app.route('/')
def show_questions():
	query = g.db.execute('select * from questions order by id asc')
	questions = [dict(id=row[0], author=row[1], text=row[2]) for row in query.fetchall()]
	return render_template('main.html',questions=questions)

@app.route('/view',methods=['GET'])
def show_answers():
	qn = request.args.get('q')
	query = g.db.execute('select * from answers where qn = ?',[qn])
	answers = [dict(id=row[0], qn=row[1], written_by=row[2], text=row[3]) for row in query.fetchall()]

	query = g.db.execute('select id,text from questions where id=?',[qn])
	question = [dict(id=row[0],text=row[1]) for row in query.fetchall()][0]
	return render_template('question.html',answers=answers,question=question)

@app.route('/addQ',methods=['POST'])
def add_question():
	data = request.json
	query = g.db.execute('insert into questions(author, text) values ( ?, ?)',[data['asker'],data['question']])
	g.db.commit()
	query = g.db.execute('select * from questions order by id asc')
	questions = [dict(id=row[0], author=row[1], text=row[2]) for row in query.fetchall()]
	return render_template('question_list.html',questions=questions)

@app.route('/addA',methods=['POST'])
def add_answer():
	data = request.json
	query = g.db.execute('insert into answers(qn, written_by,text) values ( ?,?,?)',[data['qn'],data['written_by'],data['text']])
	g.db.commit()
	query = g.db.execute('select * from answers where qn = ?',[data['qn']])
	answers = [dict(id=row[0], qn=row[1], written_by=row[2], text=row[3]) for row in query.fetchall()]
	return render_template('answer_list.html',answers=answers)

if __name__ == '__main__':
	app.run()

