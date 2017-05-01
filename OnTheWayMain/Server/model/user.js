var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var postSchema = new Schema({
    email: String,
    password: String,
    username: String
});

module.exports = mongoose.model('User', postSchema);