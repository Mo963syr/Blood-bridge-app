const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const appointmentSchema = new Schema({
  donorId: String,
  donorname: String,
  needyId: String,
  needyname: String,
  appointmentDateTime: String,
});

module.exports = mongoose.model('Appointment', appointmentSchema);
