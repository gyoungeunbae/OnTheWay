var express = require('express')
var app = express()
var router = app.Router();

//상대경로 지정 (../)
var path = require('path')
var Post = require('../model/post')

//database setting
var mongoose = require('mongoose')
// connect to database
mongoose.connect('mongodb://localhost:27017/ontheway')



//router
router.post('/', function(req, res) {
        var newPost = Post()
        //클라이언트의 요청을 바디파서가 해석 = req.body (object형태)
        newPost.text = req.body.text
        newPost.image = req.body.image

        //쿼리 날리기
        newPost.save(function(err, post) {
            if (err) {
                return res.send(err);
            }
            return res.send({ id: post.id})
        })
    })

router.get('/', function(req, res) {
        Post.find({}).sort({post_created: -1}).exec(function(err, posts) {
            if (err) {
                return res.send(err)
            } 
            console.log(posts[0]) //posts[0]가 object 형태??
            return res.send({"posts": posts})
        })
    })


router.get('/:id', function(req, res) {
        Post.findById(req.params.id, function(err, post) {
            if (err) {
                return res.send(err)
            }
            // console.log(post)
            return res.send({ "post": post })
        })
    })

router.put('/:id', function(req, res) {
        Post.findByIdAndUpdate(req.params.id, req.body, function(err, result) {
            if (err) {
                return res.send(err)
            }
            
            Post.findById(req.params.id, function(req, result) {
                return res.json({"post" : result })
            })
        })
    })

router.delete('/:id', function(req, res) {
        //url 받아오는 방식
        Post.findByIdAndRemove(req.params.id, function(err) {
            if (err) {
                return res.send(err)
            }
            return res.json({ "deleted": 1 })
        })
    })


//router의 모듈화
module.exports = router