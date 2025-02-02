const express = require('express');
const router = express.Router();
const mongoose = require('mongoose');
const compatibility = require('../models/blood_compatibility.model');

router.post('/compatibility', async (req, res) => {
  try {
    const { _id, compatibleWith } = req.body;
    if (!_id || !compatibleWith) {
      return res.status(400).json({ msg: 'Please enter all fields' });
    }

    const newCompatibility = new compatibility({
      _id,
      compatibleWith,
    });
    await newCompatibility.save();
    return res.status(200).json({ msg: 'Compatibility added successfully' });
  } catch (err) {
    return res.status(500).json({ msg: err.message });
  } 
});


module.exports = router;
