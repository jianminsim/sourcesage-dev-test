angular.module('qa.controllers', [])

.controller('AuthCtrl', function($scope, $rootScope, AuthService) {
  $scope.user = {
    email: '',
    password: ''
  };
  
  $scope.login = function() {
    AuthService.login($scope.user).success(function(data) {
      if (data.status == 1) {
        $rootScope.logged = 1;
      }
    });
  };
})

.controller('QuestionListCtrl', function($scope, QuestionService) {
  $scope.questions = QuestionService.all();
})