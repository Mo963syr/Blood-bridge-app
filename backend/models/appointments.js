const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const appointmentSchema = new Schema({
needyId:String,
appointmentDateTime:String
});

module.exports = mongoose.model('Appointment', appointmentSchema);
