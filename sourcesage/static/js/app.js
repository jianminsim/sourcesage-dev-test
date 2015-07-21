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

});

// Ref : http://codepen.io/victormejia/pen/jkiDd
app.directive('gravatar', function () {
  
  var defaultGravatarUrl = "http://www.gravatar.com/avatar/000?s=100";
  var regex = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
  
  function getGravatarUrl(email) {
    if (!regex.test(email))
      return defaultGravatarUrl;
    
    return 'http://www.gravatar.com/avatar/' + md5(email) + ".jpg?s=100";
  }
  
  function linker(scope) {
    scope.url = getGravatarUrl(scope.email);
    
    scope.$watch('email', function (newVal, oldVal) {
      if (newVal !== oldVal) {
        scope.url = getGravatarUrl(scope.email);
      }
    });
  }
  
  return {
    template: '<img ng-src="{{url}}"></img>',
    restrict: 'EA',
    replace: true,
    scope: {
      email: '='
    },
    link: linker
  };
  
});