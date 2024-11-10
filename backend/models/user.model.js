const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const userSchema = new Schema({
    firstName: String,
    lastName: String,       // حقل الاسم الأخير
    Number: String,       // حقل الاسم الأخير
    location: String,        // حقل مكان السكن
    bloodType: String,       // حقل زمرة الدم     // حقل زمرة الدم
    email: String,
    password: String,
    resetpassword:String
});

module.exports = mongoose.model('User', userSchema);
