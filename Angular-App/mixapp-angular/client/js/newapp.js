'use strict';
var myApp = angular.module('requestApp', []);

myApp.controller('RequestController', ['$scope', '$http', function($scope, $http) {
    
    $scope.callhttp = function() {
    	//$scope.msg = 'Calling http://www.appdynamics.com';

		$http({
		  method: 'GET',
		  url: '/crossapp'
		}).then(function successCallback(response) {
		    // this callback will be called asynchronously
		    // when the response is available
		    $scope.status = response;
		    console.log(response);
		  }, function errorCallback(response) {
		    // called asynchronously if an error occurs
		    // or server returns response with an error status.
		    $scope.status = response;
		    console.log(response);
		  });
	}

    $scope.calljava = function() {
    	$scope.msg = 'Calling Java App';

  	}

    $scope.callphp = function() {
    	$scope.msg = 'Calling PHP App';
  	
  	}

    $scope.callnode = function() {
    	$scope.msg = 'Calling Node.js App';
  	
  	}

    $scope.callpython = function() {
    	$scope.msg = 'Calling Python App';
  	
  	}

}]);