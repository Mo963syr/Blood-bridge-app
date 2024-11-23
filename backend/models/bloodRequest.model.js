const mongoose = require('mongoose');

const bloodRequestSchema = new mongoose.Schema({
  medecalreport: {
    type: String,
  },
  location: {
    type: String,
    required: [true, 'Location is required'],
    trim: true,
  },
  bloodType: {
    type: String,
    required: [true, 'Blood type is required'],
    enum: ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
  },
  urgencyLevel: {
    type: String,
    required: [true, 'Urgency level is required'],
    enum: ['low', 'medium', 'high'],
  },
  requestneedytype: {
    type: String,
    default: 'external',
  },
  requestStatus: {
    type: String,
    default: 'active',
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
});

const BloodRequest = mongoose.model('BloodRequest', bloodRequestSchema);

module.exports = BloodRequest;
