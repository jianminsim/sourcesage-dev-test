angular.module('qa.controllers', [])

.controller('QuestionListCtrl', function($scope, QuestionService) {
  $scope.questions = QuestionService.all();
})