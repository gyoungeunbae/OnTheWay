var express = require('express')
var app = express()
var router = express.Router();



router.get('/', function(req, res){
    //session 삭제
  req.logout();
  res.redirect('/login');
  console.log('logout')
});




//router의 모듈화
module.exports = router