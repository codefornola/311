var express    = require('express');
var app        = express();
var bodyParser = require('body-parser');
var path       = require('path');
var routes     = require('./routes');

app.use(bodyParser.json());

app.use(function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept');
    next();
});

app.use('/api', routes);

app.get('/', function(req, res) {
    res.sendFile(path.join(__dirname + '/index.html'));
});


var port = process.env.PORT || 3000;
app.listen(port, function() {
  console.log('Server running on port ' + port);
});
