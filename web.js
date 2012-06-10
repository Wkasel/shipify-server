var express = require('express');

var app = express.createServer(express.logger());
var redis = require('redis-url').connect(process.env.REDISTOGO_URL);


app.get('/', function(request, response) {
  redis.set('foo', 'bar');

  redis.get('foo', function(err, value) {
    response.send('Hello!'+value);
  });


});

var port = process.env.PORT || 5000;
app.listen(port, function() {
  console.log("Listening on " + port);
});