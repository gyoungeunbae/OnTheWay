var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy
var session = require('express-session')

var app = express();

mongoose.connect('mongodb://localhost:27017/db');



app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));
app.use(session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 1000 * 60 * 1 }
}))
app.use(passport.initialize());
app.use(passport.session());

var routes = require('./routes');

app.use('/ontheway', routes);

app.set('port', process.env.PORT || 8080);

var server = app.listen(app.get('port'), function(){
    console.log('server started');
});
