// routes/auth.js
const express = require('express');
const router = express.Router();
const User = require('../models/user.model');

// مكتبة bcrypt للتحقق من كلمة المرور
const bcrypt = require('bcrypt');

// تسجيل الدخول
router.post('/signin', async (req, res) => {
  const { email, password } = req.body;

  try {
    const user = await User.findOne({ email });
    console.log(user);
    if (!user) {
      console.log('User not found');
      return res.status(400).json({ message: 'User not found' });
    }
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      console.log('Invalid credentials');
      return res.status(400).json({ message: 'Invalid credentials' });
    } else if (isMatch && password.trim() !== null) {
      // if(user)
if(user.role=='doctor'){

   return   res.status(200).json({ message: 'Sign in successful' ,status:'doctor dashboard'});
      // console.log('Sign in successful');
    }else if(user.role=='user'){

     return res.status(200).json({ message: 'Sign in successful' ,status:'user dashboard'});
      // console.log('Sign in successful');
    }
  
  }
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

module.exports = router;
