var express = require('express')
var router = express.Router();
var multer = require('multer')
var User = require('../model/user'); //user폴더를 import함 
var userLocation = require('../model/userLocation');
var passport = require('passport')
var LocalStrategy = require('passport-local').Strategy;
var session = require('express-session');
var path = require('path')

passport.serializeUser(function(user, done) {
  console.log('passport session save :', user.id)
  done(null, user.id);
});

//session에서 id로 user 찾아서  
passport.deserializeUser(function(id, done) {
  User.findById(id, function(err, user) {
    console.log('passport session get id:', id)
    console.log('eeee')
    done(err, user);
  });
});



//업로드 이미지파일 이름과 저장소 지정
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
      // cb 콜백함수를 통해 전송된 파일 저장 디렉토리 설정
    cb(null, __dirname +'/../uploads')
  },
  filename: function (req, file, cb) {
      // cb 콜백함수를 통해 전송된 파일 이름 설정
    cb(null, Date.now() + path.extname(file.originalname))
  }
})
var upload = multer({ storage: storage })
//userLocation

router.route('/user/:id').put(function(req, res) {
    //id로 유저 찾아서 업데이트
    User.findByIdAndUpdate(req.params.id, req.body, function(err, result) {
        if (err) {
            console.log("update fail")
            return res.send(err)
        }
        
        User.findById(req.params.id, function(req, result) {
            console.log("update success")
            return res.send(result)
        })
    })
})


//이미지 업로드
router.route('/upload')
    .post(upload.single('image'), function(req, res){
        console.log(req.file)
        if (req.file) {
            // 이미지id
            console.log("upload success")
            return res.json({"ok": req.file.filename})
        } 
        res.sendStatus(404)
        
})


//회원가입
router.route('/register')
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
            newUser.image = "image";
            newUser.coordinates = [1, -1];
      
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

//로그인
router.route('/login').post(function(req, res, next) {
    passport.authenticate('local-login', function(err, user, info) {
    if(err) return res.status(500).json(err);
    if(!user) return res.status(401).json(info.message)
    req.login(user, function(err) {
      if (err) { return next(err); }
      //return res.json(user);
      console.log("login success")
      return res.send({ message : 1})
    })
  })(req, res, next);
});



//세션
router.route('/session').get(function(req, res) { 
    if (!req.user) {
      console.log("there is no user in session")
      return res.sendStatus(401)
    }
    if(req.user) {
    console.log('bbbbbb')

      console.log("there is a user in session")
      console.log(req.user);
      res.json(req.user);
    }
});

//로그아웃
router.route('/logout').get(function(req, res) {
    req.logout();
    res.redirect('/login');
    console.log('logout')
});

//이메일로 비번 찾기
router.route('/email').post(function(req, res) {
    User.find({email: req.body.email}, function(err, user) {
        if (err) {
            return res.send({ message: 'error'});
            print("error")
        }
        if (user.length == 1) {
            return res.json({ 'password': user[0].password})
        } else {
            console.log("not vaild email")
            return res.send({message: 'not valid email'});
        }
    });
});




module.exports = router;