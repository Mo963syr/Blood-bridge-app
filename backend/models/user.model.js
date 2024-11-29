const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
  firstName: String,
  lastName: String,
  number: String,
  email: String,
  password: String,
  role: {
    type: String,
    enum: ['doctor', 'user','cordinator'],
    required: true,
    default: 'user',
  },
  images: [{ type: Schema.Types.ObjectId, ref: 'Image' }], 
});

module.exports = mongoose.model('User', userSchema);
