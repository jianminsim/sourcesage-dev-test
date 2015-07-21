var app = angular.module('SourceSageQA', [ 'ionic', 'qa.services', 'qa.controllers' ]);

app.config(function($interpolateProvider){
    $interpolateProvider.startSymbol('[[').endSymbol(']]');
});

app.config(function($stateProvider, $urlRouterProvider) {
  $stateProvider
    .state('home', {
      url: '/',
      templateUrl: 'static/partials/question/list.html',
      controller: 'QuestionListCtrl',
      data: { requireLogin: true }
    })
    .state('login', {
      url: '/auth/login',
      templateUrl: 'static/partials/auth/login.html',
      controller: 'AuthCtrl',
      data: { requireLogin: false }
    });

  $urlRouterProvider.otherwise('/');
});

app.run(function ($rootScope, $location, $window) {

  $rootScope.$on('$stateChangeStart', function (event, toState, toParams) {
    var requireLogin = toState.data.requireLogin;
    if (requireLogin && !$window.sessionStorage.logged) {
      $location.path("/auth/login");
    } else if (toState.name == 'login' && $window.sessionStorage.logged == 1) {
      $location.path("/");
    }
  });

})