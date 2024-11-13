const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
  firstName: String,
  lastName: String, // حقل الاسم الأخير
  Number: String, // حقل الاسم الأخير
  location: String, // حقل مكان السكن
  bloodType: String, // حقل زمرة الدم     // حقل زمرة الدم
  email: String,
  password: String,
  role: { type: String, usertype: ['doctor', 'user', 'admin'], required: true ,default:'user' },
});
// التحقق من كلمة المرور
userSchema.methods.comparePassword = async function (password) {
  return await bcrypt.compare(password, this.password);
};
module.exports = mongoose.model('User', userSchema);
