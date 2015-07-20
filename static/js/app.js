var app = angular.module('SourceSageQA', [ 'ionic', 'qa.services', 'qa.controllers' ]);

var options = {};
options.api = {};
options.api.base_url = "/api/v1";

app.config(function($interpolateProvider){
    $interpolateProvider.startSymbol('[[').endSymbol(']]');
});

app.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'static/partials/question/list.html',
      controller: 'QuestionListCtrl'
    })
    .state('login', {
      url: '/auth/login',
      templateUrl: 'static/partials/auth/login.html'
    });

  $urlRouterProvider.otherwise('/');
});