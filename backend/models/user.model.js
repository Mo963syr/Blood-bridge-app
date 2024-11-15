const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
  firstName: String,
  lastName: String,

  Number: String,

  location: String,

  bloodType: String,

  email: String,
  password: String,
  role: {
    type: String,
    usertype: ['doctor', 'user', 'admin'],
    required: true,
    default: 'user',
  },
});

userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};
module.exports = mongoose.model('User', userSchema);
