const mongoose = require('mongoose');
const dayjs = require('dayjs');
const Schema = mongoose.Schema;
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
  fullName: {
    type: String,
  },
  requestStatus: {
    type: String,
    default: 'active',
  },
  createdAt: {
    type: Date,
    default: Date.now,
    get: (timestamp) => dayjs(timestamp).format('YYYY-MM-DD'),
  },
  time: {
    type: Date,
    default: Date.now,
    get: (timestamp) => dayjs(timestamp).format('HH:mm:ss'),
  },
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
});

bloodRequestSchema.set('toJSON', { getters: true });
bloodRequestSchema.set('toObject', { getters: true });

const BloodRequest = mongoose.model('BloodRequest', bloodRequestSchema);

module.exports = BloodRequest;
