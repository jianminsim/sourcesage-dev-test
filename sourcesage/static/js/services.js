var api_endpoint = '/api';

angular.module('qa.services', [])

.factory('QuestionService', function($http) {
  var questions = [
    {id: 1, content: "1 + 1 = ?", author: "User 1", time: "2 minutes ago"},
    {id: 2, content: "0 / 0 = ?", author: "User 2", time: "5 years ago"},
    {id: 3, content: "Why 1 + 1 = 10 ?", author: "User 3", time: "10 years ago"}
  ];

  return {
    all: function() {
      return questions;
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