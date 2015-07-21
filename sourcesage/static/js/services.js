var api_endpoint = '/api';

function Question(data) {
  this.id = data.id;
  this.content = data.content;
  this.author_id = data.author_id;
  this.author = data.author;
  this.created_time = data.created_time;
  this.comments = [];
}

angular.module('qa.services', [])

.factory('socket', function ($rootScope) {
  var namespace = '/qa';
  var socket = io.connect('http://' + document.domain + ':' + location.port + namespace);
  
  socket.on('connect', function() {
      console.log('Connected to WebSocket !');
  });
  
  socket.on('disconnect', function() {
      console.log('Disconnected from WebSocket !');
  });
  
  return {
    on: function (eventName, callback) {
      socket.on(eventName, function () {  
        var args = arguments;
        $rootScope.$apply(function () {
          callback.apply(socket, args);
        });
      });
    },
    emit: function (eventName, data, callback) {
      socket.emit(eventName, data, function () {
        var args = arguments;
        $rootScope.$apply(function () {
          if (callback) {
            callback.apply(socket, args);
          }
        });
      })
    }
  };
})

.factory('QuestionService', function($http, socket) {
  var questions = [];
  
  socket.on('newquestion', function(data) {
    questions.unshift(new Question(data));
  })

  return {
    getPages: function(limit, offset, callback) {
      $http.get(api_endpoint + '/questions?limit=' + limit + '&offset=' + offset).success(function (data) {
        var rows = data.questions;
        for (qid in rows) {
          questions.push(new Question(rows[qid]));
        }
        callback(questions);
      });
    },
    create: function(question) {
      $http.post(api_endpoint + '/questions', question).success(function (data) {
        console.log(data);
      });
    },
    get: function(qId) {
      return questions[qId];
    }
  }
})

.factory('AuthService', function($http) {
  return {
    login: function(user) {
      return $http.post(api_endpoint + '/login', user);
    },
    signup: function(user) {
      return $http.post(api_endpoint + '/signup', user);
    }
  }
});