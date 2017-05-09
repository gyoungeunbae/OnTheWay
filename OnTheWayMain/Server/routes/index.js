var express = require('express')
var router = express.Router();

var User = require('../model/user'); //user폴더를 import함 
var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy;
var session = require('express-session')

router.route('/user/register')
  .post(function(req, res) {
    // 중복 유저 검사
    User.find({email: req.body.email}, function(err, user) {
      console.log(user);
        if (err) {
            console.log("err")
            return res.send({ message: 'error'});
        }
        if (user.length > 0) {
            console.log("existing user")
            return res.send({message: 0});
        } else {
            console.log("register success")
            var newUser = new User();
            newUser.email = req.body.email;
            newUser.password = req.body.password;
            newUser.username = req.body.username;
      
            newUser.save(function(err) {
                if (err) {
                    return res.send({ message: err });
                }
                console.log("db saved")
                res.send({ message: 1 });
            });
        }
    });
    // todo: 중복 유저에 대한 대응 
});

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

router.route('/user/login').post(function(req, res, next) {
    passport.authenticate('local-login', function(err, user, info) {
    if(err) return res.status(500).json(err);
    if(!user) return res.status(401).json(info.message)
    req.login(user, function(err) {
      if (err) { return next(err); }
      //return res.json(user);
      return res.send({ message : 1})
    })
  })(req, res, next);
});



//세션 가져오기
router.route('/user/login').get(function(req, res) {
    console.log("req.user =", req.user)
    if (!req.user) {
      console.log("there is no user in session")
      return res.sendStatus(401)
    }
    else {
      console.log("there is a user in session")
      res.json(req.user);
    }
});

router.route('/user/logout').get(function(req, res) {
    req.logout();
  res.redirect('/login');
  console.log('logout')
});

router.route('/user/email').post(function(req, res) {
    User.find({email: req.body.email}, function(err, user) {
        if (err) {
            return res.send(err)
        }
        if (!user) {
            console.log("no user")
            return res.send({ message: 'no user'});
        }
        if (user.length == 1) {
            return res.json({ 'password': user[0].password})
            
        } 
    });
});

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



module.exports = router;