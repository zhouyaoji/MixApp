'use strict';
var myApp = angular.module('requestApp', []);

myApp.controller('RequestController', ['$scope', '$http', function($scope, $http) {
    
    $scope.request = function(req_url) {
    // Url paarameters passed in 
    var req_url;

    // Calling Node.js backend to get response
    $http({
      method: 'POST',
      url: '/http',
      data: { requesturl: req_url}
    }).then(function successCallback(response) {
        $scope.status = 'SUCCESS';
        $scope.data = response;
        console.log(response);
      }, function errorCallback(response) {
        $scope.status = 'ERROR';
        $scope.data = response;
        console.log(response);
      });
    }

    $scope.callhttp = function() {
      $scope.msg = 'Calling www.appdynamics.com';
      $scope.request('http://www.appdynamics.com');
    }

    $scope.calljava = function() {
      $scope.msg = 'Calling Java App';
      $scope.request('http://java_app:8080');
    }

    $scope.callphp = function() {
      $scope.msg = 'Calling PHP App';
      $scope.request('http://php_app:80/info.php');
    }

    $scope.callpython = function() {
      $scope.msg = 'Calling Python App';
      $scope.request('http://python_app:9000');
    }

    $scope.callnode = function() {
      $scope.msg = 'Calling Node.js App';
      $scope.request('http://nodejs_app:3000');
    }

}]);
