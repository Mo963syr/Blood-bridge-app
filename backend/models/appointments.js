const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const appointmentSchema = new Schema({
  donorId: String,
  donorname: String,
  needyId: String,
  needyname: String,
  appointmentDateTime: String,
  notes: String,
  status: String,
   createdAt: {
      type: Date,
      default: Date.now,
      get: (timestamp) =>
        dayjs(timestamp).format('YYYY-MM-DD'),
    },
    time: {
      type: Date,
      default: Date.now,
      get: (timestamp) =>
        dayjs(timestamp).format('HH:mm:ss'),
    },
});

module.exports = mongoose.model('Appointment', appointmentSchema);
