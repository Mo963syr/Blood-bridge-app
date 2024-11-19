const express = require('express');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const User = require('../models/User.model');
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

    if (user.role === 'doctor') {
      return res.status(200).json({
        message: 'Sign in successful',
        status: 'doctor dashboard',
        token, 
      });
    } else if (user.role === 'user') {
      return res.status(200).json({
        message: 'Sign in successful',
        status: 'user dashboard',
        token, 
      });
    }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

router.post('/signup', async (req, res) => {
  const { firstName, lastName, number, location, bloodType, email, password } =
    req.body;

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
      location,
      bloodType,
      email,
      password: hashedPassword,
    });

    await user.save();

    const userResponse = {
      _id: user._id,
      firstName: user.firstName,
      lastName: user.lastName,
      number: user.number,
      location: user.location,
      bloodType: user.bloodType,
      email: user.email,
      role: user.role,
    };

    if (user.role === 'user') {
      return res.status(201).json({
        message: 'User created successfully',
        user: userResponse,
      });
    } else if (user.role === 'doctor') {
      return res.status(201).json({
        message: 'Doctor dashboard',
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

module.exports = router;
