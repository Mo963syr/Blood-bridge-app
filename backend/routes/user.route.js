const express = require('express');
const bcrypt = require('bcrypt');
const User = require('../models/user.model');
const router = express.Router();

router.post('/signup', async (req, res) => {
  try {
    // التحقق مما إذا كان البريد الإلكتروني موجودًا بالفعل
    const existingUser = await User.findOne({ email: req.body.email });
    if (existingUser) {
      return res.json({ message: 'Email is not available' });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(req.body.password, 10);

    // إنشاء مستخدم جديد مع الحقول الإضافية
    const user = new User({
      firstName: req.body.firstName,
      lastName: req.body.lastName,
      Number: req.body.Number,
      location: req.body.location,
      bloodType: req.body.bloodType,
      email: req.body.email,
      password: hashedPassword,
    });

    // حفظ المستخدم في قاعدة البيانات
    await user.save();
    if (user.role == 'user') {
      // الاستجابة مع بيانات المستخدم دون إرسال كلمة المرور
      return res.json({
        message: 'User created successfully',
        user: {
          firstName: req.body.firstName,
          lastName: req.body.lastName,
          Number: req.body.Number,
          location: req.body.location,
          bloodType: req.body.bloodType,
          email: req.body.email,
          role: user.role,
        },
      });
    } else if (user.role == 'doctor') {
      return res.json({
        message: 'doctor dashboard',
        user: {
          role: user.role,
        },
      });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred during sign up' });
  }
});

router.put('/api/users/:id', async (req, res) => {
  try {
    const userId = req.params.id;
    const updateData = req.body;
    const user = await User.findByIdAndUpdate(userId, updateData, {
      new: true,
    });
    res.status(200).json(user);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
});

module.exports = router;
