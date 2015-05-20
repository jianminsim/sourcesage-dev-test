var socket = io.connect('http://104.199.175.158/');

var qna = angular.module('qna', []);

qna.controller('QnaWidgetCtrl', function($scope, $http) {
    var PLACEHOLDER_TEXT_DEFAULT = 'Write a question!';
    var ANSWER_PLACEHOLDER_TEXT_DEFAULT = 'Write an answer!';
    var questionsList = [];

    $http.get('api/questions')
    .success(function(questionsData) {
      $scope.questionsList = questionsData;
    });

    /**
     * Callback: Things to do on user submitting a question.
     */
    var onQuestionSubmit = function() {
        $scope.questionInput = null;
    };

    $scope.placeholderText = PLACEHOLDER_TEXT_DEFAULT;
    $scope.answerPlaceholderText = ANSWER_PLACEHOLDER_TEXT_DEFAULT;
    $scope.onQuestionSubmit = onQuestionSubmit;


    /**
      * Question submission handler.
      */
    $scope.submit = function(question, callback) {
        $scope.question = question;

	$scope.sendingDataToggle = true;
	$http.post('api/questions', { questionString: question })
	.success(function(resData) {
		$scope.sendingDataToggle = false;
		if (callback) {
		    callback();
		}
	})
	.error(function() {
		$scope.sendingDataToggle = false;
		console.log('error in submitting question to server.');
	});


    };


    /**
      * Answer submission handler.
      */
    $scope.submitAnswer = function(answer, question, callback) {
	var qid = question.id;

	$scope.sendingAnswerDataToggle = true;
	$http.post('api/questions/' + qid + '/answers', { answerString: answer })
	.success(function(resData) {
		$scope.sendingAnswerDataToggle = false;
		if (callback) {
		    callback();
		}
	})
	.error(function() {
		$scope.sendingAnswerDataToggle = false;
		console.log('error in submitting answer to server.');
	});


    };

    socket.on('newQuestionAdded', function(newQuestion) {
	var questions = $scope.questionsList;
	var qid = _.findIndex(questions, function(question) {
		return question.id == newQuestion.id;
	});
	if (qid == -1) { // check if question is already in the list.
		$scope.questionsList = questions.concat(newQuestion);
		$scope.$apply();
	}
    });

    socket.on('newAnswerAdded', function(newData) {
	var parentQuestion = newData.question;
	var newAnswer = newData.answer;
	var questions = $scope.questionsList;
	var qid = _.findIndex(questions, function(question) {
		return question.id == parentQuestion.id;
	});
	if (qid !== -1) {
		var question = $scope.questionsList[qid];
		question.answers = question.answers.concat(newAnswer);
		$scope.$apply();
	}
    });

});

