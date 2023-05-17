var express = require('express'),
    path = require('path');

var src = path.join(__dirname, '/public');

var app = express();

app.use(express.static(src));

app.use('/.well-known', express.static('well-known'));

app.get('/', function (req, res) {
  res.sendFile(src + '/index.html');
});

app.get('/.well-known/webfinger', function(req, res) {
  if (req.query && req.query.resource === 'acct:corey@x64.co') {
    res.sendFile(src + '/identity.json');
  }
});

app.listen(3001, function (){
  console.log('Server started');
});
