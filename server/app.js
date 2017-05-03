var express = require('express')
var app = express()

//post의 res 받을때 필요함
var bodyParser = require('body-parser')
var router = require('./router/index')
var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy
var session = require('express-session')
var flash = require('connect-flash')

//bodyparser 로 post 의 응답 받기(json형태, ascii 형태)
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true}));

//static 디렉토리 여기로 사용하겠다
app.use(express.static('public'));

//session
app.use(session({
  secret: 'keyboard cat',
  resave: false,
  saveUninitialized: true
}))

//passport
app.use(passport.initialize());
app.use(passport.session());

//flash 
app.use(flash());

// api에 대한 router는 main을 써라
app.use('/ontheway',router)


// attach server
app.set('port', process.env.PORT || 3000)
//listen = 앱에 포트 지정하기
var server = app.listen(app.get('port'), function() {
    console.log('start express server on port 3000');
});