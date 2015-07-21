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

.factory('QuestionService', function($http) {
  var questions = [];

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