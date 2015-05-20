var express = require('express');
var app = express();
var bodyParser = require('body-parser');
var NodeCache = require('node-cache');
var cache = new NodeCache({ checkPeriod: 120 });
var _ = require('lodash');
var uuid = require('node-uuid');

/**
  * Common middleware.
  */
app.use(express.static(__dirname + '/public'));
app.use(bodyParser.json());

// TODO: change to a map with uuid as key for faster lookup.
var questions = [];

cache.set('questions', questions); // Using memory cache to store questions/answers.

/**
  * Routes.
  */
app.get('/', function(req, res) {
	return res.sendFile(__dirname + '/public/index.html');
});

app.get('/api/questions', function(req, res) {
	return res.json(cache.get('questions'));
});

app.post('/api/questions', function(req, res) {
	var question = req.body;
	var questions = cache.get('questions');

	question = new QuestionModel(question.questionString);

	questions.push(question);

	cache.set('questions', questions, function() {
		io.emit('newQuestionAdded', question);
		return res.json(question);
	});
});

app.post('/api/questions/:questionId/answers', function(req, res) {
	var questions =  cache.get('questions');
	var qid = _.findIndex(questions, function(question) {
		return question.id == req.params.questionId;
	});
	var question = questions[qid];
	var answer = new AnswerModel(req.body.answerString, question.id);

	question.answers.push(answer);

	cache.set('questions', questions, function() {
		io.emit('newAnswerAdded', { answer: answer, question: question });
		res.json(answer);
	});
});

/**
  * Models.
  */
function QuestionModel(questionString) {
	return {
		id: uuid.v4(),
		timestamp: Date.now(),
		questionString: questionString || '',
		answers: []
	}
}

function AnswerModel(answerString, questionParentId) {
	return {
		id: uuid.v4(),
		timestamp: Date.now(),
		answerString: answerString || '',
		questionParentId:  questionParentId
	}
}



var server = app.listen(80);

var io = require('socket.io')(server);
io.on('connection', function(socket) {
	console.log('got a connection');
});
