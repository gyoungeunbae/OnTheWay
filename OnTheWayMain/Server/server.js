var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');

var app = express();

mongoose.connect('mongodb://localhost:27017/ontheway');



app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));



var routes = require('./routes');

app.use('/ontheway', routes);

app.set('port', process.env.PORT || 8080);

var server = app.listen(app.get('port'), function(){
    console.log('server started');
});
