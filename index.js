var express = require('express'),
    path = require('path');

var src = path.join(__dirname, '/public');

var app = express();

app.use(express.static(src));

app.get('/', function (req, res) {
  res.sendFile(src + '/index.html');
});

app.listen(3001, function (){
  console.log('Server started');
});
