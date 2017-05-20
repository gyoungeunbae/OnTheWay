var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var postSchema = new Schema({
    email: String,
    password: String,
    username: String,
    image: String
});

postSchema.methods.validPassword = function( pwd ) {
    // EXAMPLE CODE!
    return ( this.password === pwd );
};

module.exports = mongoose.model('User', postSchema);