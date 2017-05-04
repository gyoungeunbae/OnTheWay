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
mongoose.connect('mongodb://localhost:27017/ontheway')

passport.use('local-register', new LocalStrategy({
    usernameField: 'email',
    passwordField: 'password',
    passReqToCallback: true
},function(req, email, password, done) {
    User.findOne({ email : email }, function (err, user) {
            console.log("auth ing")
      //db에러?
      if (err) { return done(err); }
      //이메일 틀려서 미발급
      if (user) {
        console.log("already existing user")
        return done(null, false, { message: 'already existing user' });
      }
      else {
        var newUser = new User();
        newUser.username = req.body.username;
        newUser.password = req.body.password;
        newUser.email = req.body.email;

        //db에 삽입
        newUser.save(function(err, savedUser) {
                if (err) {
                        console.log(err);
                        //return res.status(500).send();
                }
                console.log('new user saved in db')
                //return res.status(300).send();
        })
        if (err) throw err
        return done(null, user);
        };
    });
  }
));





//db에 등록된 사용자 명단 불러오기
router.get('/', function(req, res) {
        console.log('came to register')
    // get all the users
    User.find({}, function(err, users) {
            if (err) throw err;
            console.log(users);
            return res.send({"login": "ok"})
    // object of all the users
    });
})



router.post('/', passport.authenticate('local-register', {
        successRedirect: '/login',
        failureRedirect: '/register',
        failureFlash: true})
)


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
module.exports = router