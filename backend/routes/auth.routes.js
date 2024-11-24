const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/user.model');
const router = express.Router();

router.post('/signin', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Invalid credentials' });
    }

    const token = jwt.sign(
      { userId: user._id, role: user.role },
      process.env.JWT_SECRET || 'yourSecretKey',
      { expiresIn: '1h' }
    );

    // تضمين userId في الاستجابة
    const response = {
      message: 'Sign in successful',
      token,
      userId: user._id, // إضافة المعرف
      role: user.role,
    };

    if (user.role === 'doctor') {
      response.status = 'doctor dashboard';
    } else if (user.role === 'user') {
      response.status = 'user dashboard';
    }

    return res.status(200).json(response);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

router.post('/signup', async (req, res) => {
  const { firstName, lastName, number, email, password } = req.body;

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email is already in use' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    const user = new User({
      firstName,
      lastName,
      number,
      email,
      password: hashedPassword,
    });

    await user.save();

    const userResponse = {
      _id: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
      number: user.number,
      email: user.email,
      role: user.role,
    };

    // تضمين userId في الاستجابة
    return res.status(201).json({
      message: 'User created successfully',
      user: userResponse,
      userId: user._id, // إضافة المعرف
    });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'An error occurred during sign up' });
  }
});

module.exports = router;
