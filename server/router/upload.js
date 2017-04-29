var express = require('express')
var app = express()
var router = app.Router();

var multer = require('multer')

//상대경로 지정 (../)
var path = require('path')
var Post = require('../model/post')

//database setting
var mongoose = require('mongoose')
// connect to database
mongoose.connect('mongodb://localhost:27017/ontheway')


//업로드 이미지파일 이름과 저장소 지정
var storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, __dirname +'/public/images')
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + path.extname(file.originalname))
  }
})
var upload = multer({ storage: storage })


//router
router.route('/')
    .post(upload.single('image'), function(req, res){
        if (req.file) {
            // console.log(req.body);
            return res.json({"ok": req.file.filename})
        }
        res.sendStatus(404)
    })

//router의 모듈화
module.exports = router