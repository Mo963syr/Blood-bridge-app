const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const appointmentSchema = new Schema({
  donorId: String,
  donorReqId: String,
  donorname: String,
  needyReqId: String,
  needyname: String,
  needyId: String,
  appointmentDateTime: String,
  notes: String,
  status: {
    required: true,
    type: String,
    enum: ['pending', 'assigned', 'completed'],
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
});

module.exports = mongoose.model('Appointment', appointmentSchema);
