var express = require('express')
var app = express()
var router = express.Router();
var path = require('path')


router.get('/', function(req, res){
    var id = req.user;
    if(!id) return res.sendStatus(404)
    return res.send({"id": id})
});




//router의 모듈화
module.exports = router