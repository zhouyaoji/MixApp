var request = require('request');

exports.crossApp = function(req, res) {
    request
        .get("http://DOTNET_IP:DOTNET_PORT")
        .on('response', function(response) {
            res.send(response);
            console.log(response.statusCode)
        })
        .on('error', function(err) {
            console.log(err)
    })
};
