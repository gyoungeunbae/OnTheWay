
var express = require('express')
var router = express.Router();

var User = require('../model/user'); //user폴더를 import함 

router.route('/user/register')
  .post(function(req, res) {
    // 중복 유저 검사
    User.find({email: req.body.email}, function(err, user) {
      console.log(user);
        if (err) {
            return res.send({ message: 'error'});
        }
        if (user.length > 0) {
            return res.send({message: 0});
        } else {
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

router.route('/user/login').post(function(req, res) {
    User.find({email: req.body.email, password: req.body.password}, function(err, user) {
        if (err) {
            return res.send({ message: 'error'});
        }
        if (user.length == 1) {
            return res.send({message: 1});
        } else {
            return res.send({message: 0});
        }
    });
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

// router.route('/user/:email')
//     //특정 포스트 불러오기 메소드
//     .get(function(req, res) {
//         User.findById(req.params.email, function(err, user) {
//             if (err) {
//                 return res.send(err)
//             }
//             console.log("1111")
//             return res.send({ "password": user.password })
//         })
//     })

module.exports = router;