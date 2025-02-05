const mongoose = require('mongoose');
const { Schema } = mongoose;

const userSchema = new Schema({
  firstName: { type: String, required: true },
  lastName: { type: String, required: true },
  number: {
    type: String,
    match: [
      /^(\+963|0)?9[0-9]{8}$/,
      'رقم الهاتف غير صحيح. يجب أن يبدأ بـ +963 أو 09.',
    ],
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,

    match: [
      /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
      'البريد الإلكتروني غير صالح. يرجى إدخال بريد إلكتروني صحيح.',
    ],
  },
  password: { type: String, required: true },
  role: {
    type: String,
    enum: ['doctor', 'user', 'coordinator','employee'],
    required: true,
    default: 'user',
  },
  images: [{ type: Schema.Types.ObjectId, ref: 'Image' }],
});

module.exports = mongoose.model('User', userSchema);
