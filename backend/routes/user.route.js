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
            location: req.body.location,
            bloodType: req.body.bloodType,
            email: req.body.email,
            password: hashedPassword,
        });

        // حفظ المستخدم في قاعدة البيانات
        await user.save();

        // الاستجابة مع بيانات المستخدم دون إرسال كلمة المرور
        res.json({
            message: 'User created successfully',
            user: {
                firstName: user.firstName,
                lastName: user.lastName,
                bloodType: req.body.bloodType,
                location: user.location,
                email: user.email
            },
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred during sign up' });
    }
});

router.post('/signin', async (req, res) => {
    try {
        // البحث عن المستخدم بالبريد الإلكتروني
        const user = await User.findOne({ email: req.body.email });
        if (!user) {
            return res.json({ message: 'User not found' });
        }

        // مقارنة كلمة المرور
        const isMatch = await bcrypt.compare(req.body.password, user.password);
        if (!isMatch) {
            return res.json({ message: 'Invalid credentials' });
        }

        // الاستجابة مع بيانات المستخدم دون إرسال كلمة المرور
        res.json({
            message: 'Sign in successful',
            user: {
                firstName: user.firstName,
                lastName: user.lastName,
                location: user.location,
                bloodType: user.bloodType,
                bloodType: user.bloodType,
                email: user.email,
            },
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'An error occurred during sign in' });
    }
});

module.exports = router;
