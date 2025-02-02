const mongoose = require('mongoose');
const Schema = mongoose.Schema;
// const express = require('express');
const blood_compatibility = new Schema({
  _id: {
    type: String,
  },
  compatibleWith: {
    type: [String],
  },
});
const compatibility = mongoose.model(
  'blood_compatibility',
  blood_compatibility
);

const bloodCompatibilityData = [
  { _id: 'O-', compatibleWith: ['O-'] },
  { _id: 'O+', compatibleWith: ['O-', 'O+'] },
  { _id: 'A-', compatibleWith: ['O-', 'A-'] },
  { _id: 'A+', compatibleWith: ['O-', 'O+', 'A-', 'A+'] },
  { _id: 'B-', compatibleWith: ['O-', 'B-'] },
  { _id: 'B+', compatibleWith: ['O-', 'O+', 'B-', 'B+'] },
  { _id: 'AB-', compatibleWith: ['O-', 'A-', 'B-', 'AB-'] },
  {
    _id: 'AB+',
    compatibleWith: ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+'],
  },
];
// إدخال البيانات في قاعدة البيانات
// compatibility.insertMany(bloodCompatibilityData).then(() => {
//   console.log(' Data inserted successfully!');
//   // mongoose.connection.close();
// });

module.exports = compatibility;
