#!/usr/bin/python

from wsgiref.simple_server import make_server
from cgi import parse_qs, escape
from pprint import pprint

qns = []
answer = []
html = """
<html>
<head>
	<title>Questions and Answers</title>
	<link href="http://maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
	<div class="container">
		<div class="col-md-6 col-md-offset-3">
			<h1 class="center page-header">QUESTIONS AND ANSWERS</h1>
			%s
		</div>
	</div>
</body>
</html>"""
ask_box = """
			<form class="form-horizontal" method="post" action="index.py">
				<h3>Ask a Question: </h3>
				<div class="form-group">
					<label for="asker" class="control-label">Asker</label>
					<input id="asker" class="form-control" type="text" name="asker">
				</div>
				<div class="form-group">
					<label for="question" class="control-label">Question</label>
					<input id="question" class="form-control" type="text" name="question">
				</div>
				<button type="submit" class="btn btn-primary col-md-2 col-md-offset-5">Submit</button>
			</form>
"""
question_list ="""
	<table class="table table-striped table-bordered" style="text-align:center">
		<thead>
			<th>Question</th>
			<th>Asker</th>
			<th>No. of answer</th>
		</thead>
		<tbody>
			%s
		</tbody>
	</table>
	"""

answer_list = """
	<table class="table table-striped table-bordered" style="text-align:center">
		<thead>
			<th>Answer</th>
			<th>By</th>
		</thead>
		<tbody>
			%s
		</tbody>
	</table>
"""
answer_box = """
	<form class="form-horizontal" method="post" action="index.py?q=%s">
		<div class="form-group">
			<label for="answered_by" class="control-label">Name</label>
			<input id="answered_by" class="form-control" type="text" name="answered_by">
		</div>
		<div class="form-group">
			<label for="answer" class="control-label">Answer</label>
			<input id="qanswer" class="form-control" type="text" name="answer">
		</div>
		<button type="submit" class="btn btn-primary col-md-2 col-md-offset-5">Submit</button>
	</form>
"""

def answer_template(question):
	return_link = """<span class="col-md-3 col-md-offset-9"><a href="/index.py">Back to main</a></span>"""
	if len(question[2]) == 0:
		return return_link
	ans = ""
	answer_format ="""
	<tr>
		<td>%s</td>
		<td>%s</td>
	</tr>
	"""
	for i in question[2]:
		val = int(i)
		ans = ans + (answer_format %(answer[val][0],answer[val][1]))
	return answer_list %(ans) + return_link

def show_question(question):
	text = """
	<div class="panel panel-default">
		<div class="panel-heading">QUESTION</div>
		<div class="panel-body">
			%s
		</div>
	</div>
	"""
	return text % question[1]

def question_template(question):
	if len(question)==0 :
		return "NO QUESTION"
	
	template = """
	<tr>
		<td>%s</td>
		<td>%s</td>
		<td><a href ="%s">%s</a></td>
	</tr>
	"""
	content = ""
	count = 0
	for qn in question:
		link = "/index.py?q="+str(count)
		content = content + (template % (qn[1],qn[0],link,str(len(qn[2]))))
		count = count+1
	return question_list % (content)


def application(environ, start_response):
	is_question_page = False
	qno = 0
	method = environ['REQUEST_METHOD']
	#separate by request cases
	if method =='POST':
		#POST request
		#either posting a question or answer
		qs = parse_qs(environ.get('QUERY_STRING'))
		if ('q' in qs):
			qno = int(qs.get('q',[''])[0])
			if qno < len(qns):
				is_question_page = True
		length = int(environ.get('CONTENT_LENGTH', '0'))
		body = environ['wsgi.input'].read(length)
		content = parse_qs(body)
		#question case
		if ('answered_by' in content) and ('answer' in content):
			answer.append([content['answer'][0], content['answered_by'][0]])
			qns[qno][2].append(len(answer)-1)
		elif ('asker' in content)and('question' in content) :
			qns.append([content['asker'][0],content['question'][0],[]])
		#answer case
	elif method =='GET':
		qs = environ.get('QUERY_STRING')
		content = parse_qs(qs)
		if ('q' in content) :
			qno = int(content.get('q',[''])[0])
			if qno < len(qns):
				is_question_page = True

	text = ""
	if is_question_page:
		text = show_question(qns[qno])
		text = text + (answer_box % (qno))
		text = text + answer_template(qns[qno])
	else:
		text = ask_box
		text = text + question_template(qns)
	response_body = html % (text or 'None')   	
	status = '200 OK'   
	# Now content type is text/html   
	response_headers = [('Content-Type', 'text/html'),   ('Content-Length', str(len(response_body)))]
	start_response(status, response_headers)
	return [response_body]

httpd = make_server('localhost', 8051, application)
httpd.serve_forever()