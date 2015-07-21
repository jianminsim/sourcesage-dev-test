angular.module('qa.controllers', [])

.controller('LoginCtrl', function($scope, $rootScope, $location, $window, $ionicPopup, AuthService) {
  $scope.user = {
    email: '',
    password: ''
  };
  
  $scope.login = function() {
    AuthService.login($scope.user).success(function(data) {
      if (data.status == 1) {
        $ionicPopup.alert({
          title: 'Login',
          template: 'Login successful !'
        });
        $window.sessionStorage.logged = 1;
        $location.path("/");
      } else {
        $ionicPopup.alert({
          title: 'Login',
          template: 'Login failed ! Please try again :)'
        });
      }
    });
  };
  
  $scope.signup = function() {
    AuthService.signup($scope.user).success(function(data) {
      if (data.status == 1) {
        $ionicPopup.alert({
          title: 'Signup',
          template: 'Signup successful !'
        });
        $window.sessionStorage.logged = 1;
        $location.path("/");
      } else {
        $ionicPopup.alert({
          title: 'Signup',
          template: 'Signup failed ! Please try again :)'
        });
      }
    });
  };
})

.controller('QuestionListCtrl', function($scope, $window, $location, QuestionService, AuthService, socket) {
  $scope.questions = [];
  $scope.new_question = {
    content: ''
  }
  $scope.page = 0;
  $scope.limit = 5;
  
  $scope.createQuestion = function(question) {
    QuestionService.create(question, function(data) {
      if (data.status == 1) {
        $scope.new_question.content = "";
      }
    });
  }
  
  $scope.logout = function() {
    AuthService.logout(function(data) {
      $window.sessionStorage.removeItem('logged');
      $location.path('/auth/login');
    });
  }
  
  $scope.loadMore = function() {
    $scope.page++;
    var skip = ($scope.page - 1) * $scope.limit;
    QuestionService.getPages(5, skip, function(data) {
      $scope.questions = data;
    });
  }
  
  $scope.loadMore();
})

.controller('QuestionViewCtrl', function($scope, $stateParams, QuestionService, socket) {
  var question_id = $stateParams.id;
  $scope.ques = {};
  $scope.new_answer = {
    content: ''
  }
  
  socket.on('question' + question_id, function(data) {
    $scope.ques.answers.push(data);
  })
  
  $scope.replyQuestion = function(answer) {
    QuestionService.reply(question_id, answer, function(data) {
      if (data.status == 1) {
        $scope.new_answer.content = "";
      }
    });
  }
  
  QuestionService.get(question_id, function(data) {
    $scope.ques = new Question(data);
  });
});