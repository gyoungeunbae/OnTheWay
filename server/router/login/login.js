var express = require('express')
var app = express()
var router = express.Router();

//상대경로 지정 (../)
var path = require('path')
var User = require('../../model/user')

var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy;


//database setting
var mongoose = require('mongoose')
// connect to database
mongoose.createConnection('mongodb://localhost:27017/ontheway')

//local-login
//db 조회
passport.use('local-login', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password'
},function(email, password, done) {
    User.findOne({ email : email }, function (err, user) {
      //db에러?
      if (err) { return done(err); }
      //이메일 틀려서 미발급
      if (!user) {
        console.log("login info incorrect email")
        return done(null, false, { message: 'Incorrect email.' });
      }
      //암호 틀려서 미발급
      if (!user.validPassword(password)) {
        console.log("login info incorrect pwd")
        return done(null, false, { message: 'Incorrect password.' });
      }
      // 여권 발급
      console.log("login info existing user")
      return done(null, user);
    });
  }
));


//db에 등록된 사용자 명단 불러오기
router.get('/', function(req, res) {
  console.log('came to login')
    // get all the users
    User.find({}, function(err, users) {
            if (err) throw err;
            console.log(users);
            return res.send({"login": "ok"})
    // object of all the users
    });
})


//로그인 시 존재하는 사용자인지 확인
router.post('/', function(req, res, next) {
  passport.authenticate('local-login', function(err, user, info) {
    if(err) return res.status(500).json(err);
    if(!user) return res.status(401).json(info.message)
    req.logIn(user, function(err) {
      if (err) { return next(err); }
      //return res.json(user);
      return res.send({ id: user.id})
    })
  })(req, res, next);
});




//strategy에서 done 성공시  serialize 해야 session처리 가능
//passport session에 user id저장
passport.serializeUser(function(user, done) {
  console.log('passport session save :', user.id)
  done(null, user.id);
});

//session에서 id로 user 찾아서  
passport.deserializeUser(function(id, done) {
  User.findById(id, function(err, user) {
    console.log('passport session get id:', id)
    done(err, user);
  });
});




//router의 모듈화
module.exports = router;