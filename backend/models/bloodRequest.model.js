const mongoose = require('mongoose');


const bloodRequestSchema = new mongoose.Schema({
  location: {
    type: String,
    required: [true, 'Location is required'],
    trim: true
  },
  bloodType: {
    type: String,
    required: [true, 'Blood type is required'],
    enum: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'], 
    
      },
  phoneNumber: {
    type: String,
    required: [true, 'Phone number is required'],
    validate: {
      validator: function (v) {
        return /^\d{10,15}$/.test(v);
      },
      message: 'Phone number should contain only numbers and be between 10-15 digits'
    },
  },
  urgencyLevel: {
    type: String,
    required: [true, 'Urgency level is required'],
    enum: ['low', 'medium', 'high'], 
  },
  createdAt: {
    type: Date,
    default: Date.now,
  }
});

const BloodRequest = mongoose.model('BloodRequest', bloodRequestSchema);

module.exports = BloodRequest;
