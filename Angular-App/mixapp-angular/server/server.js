// set up ======================================================================
var application_root = __dirname;
var path = require("path");
var express = require('express');
var app = express(); 
var port = process.env.PORT || 8000;
var bodyParser = require('body-parser');
var methodOverride = require('method-override');
var request = require('request');

// configuration ===============================================================
app.use(express.static(__dirname + '/../client/')); 		// set the static files location /public/img will be /img for users
app.use(bodyParser.urlencoded({'extended': 'true'})); // parse application/x-www-form-urlencoded
app.use(bodyParser.json()); // parse application/json
app.use(bodyParser.json({type: 'application/vnd.api+json'})); // parse application/vnd.api+json as json
app.use(methodOverride('X-HTTP-Method-Override')); // override with the X-HTTP-Method-Override header in the request

// routes ======================================================================
app.get('/', function(req, res){
	res.send('Server is running');
});

// Get url parameter from AngularJS client and make http request
app.post('/http', function(req, res) {
    //Lets configure and request
    console.log(req.body.requesturl)
    request
        .get(req.body.requesturl)
        .on('response', function(response) {
            res.send(response);
            console.log(response.statusCode)
        })
        .on('error', function(err) {
            console.log(err)
    })
});

app.listen(port);
console.log("App listening on port " + port);