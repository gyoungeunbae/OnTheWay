var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var postSchema = new Schema({
    email: String,
    password: String,
    username: String,
    image: String,
    coordinates: { type: [Number], index: '2dsphere'},
    steps: Number
});

postSchema.methods.validPassword = function( pwd ) {
    // EXAMPLE CODE!
    return ( this.password === pwd );
};

module.exports = mongoose.model('User', postSchema);