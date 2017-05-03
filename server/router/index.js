var express = require('express')
var app = express()
var router = express.Router();

//상대경로 지정 (../)
var path = require('path')

// 라우터 모듈 가져오기
var register = require('./register/register')
var login = require('./login/login')
var logout = require('./logout/logout')

//database setting
var mongoose = require('mongoose')
// connect to database
mongoose.createConnection('mongodb://localhost:27017/ontheway')


router.use('/logout', logout)
router.use('/register', register)
router.use('/login', login)

router.get('/', function(req, res) {
        res.sendFile(path.join(__dirname + '../public/main.html'))
 })

//router의 모듈화
module.exports = router;