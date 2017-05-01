
var express = require('express');
var path = require('path');
var fs = require('fs');

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
                    return res.send({ message: 'Error' });
                }
                res.send({ message: 1 });
            });
        }
    });
    // todo: 중복 유저에 대한 대응 
});


module.exports = router;