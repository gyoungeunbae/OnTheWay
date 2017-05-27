var express = require('express');
var bodyParser = require('body-parser');
var mongoose = require('mongoose');
var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy
var session = require('express-session')
var multer = require('multer')

var app = express();
var routes = require('./routes');

mongoose.connect('mongodb://localhost:27017/db');

//서버 이미지파일 저장소
app.use(express.static('uploads'))

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true,
  cookie: { maxAge: 1000 * 60 * 60 }
  //세션유지 1시간
}))
app.use(passport.initialize());
app.use(passport.session());

app.use('/ontheway', routes);

app.set('port', process.env.PORT || 8080);

var server = app.listen(app.get('port'), function(){
    console.log('server started');
});