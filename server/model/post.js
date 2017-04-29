//몽구스에게 포스트 양식 설정해주기
var mongoose = require('mongoose')
var Schema = mongoose.Schema;
var ObjectId = Schema.ObjectId;

var postSchema = new Schema({
    author: ObjectId,
    text: String,
    image: String,
    post_created: { type: Date, default: Date.now }
})


module.exports = mongoose.model('Post', postSchema)


