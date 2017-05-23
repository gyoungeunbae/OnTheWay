var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var postSchema = new Schema({
    email: String,
    coordinates: [Number]
});
module.exports = mongoose.model('UserLocation', postSchema);