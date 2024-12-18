const express = require('express');
const Appointment = require('../models/appointments');
const router = express.Router();
router.post('/appointments', async (req, res) => {
  try {
    const { needyId, appointmentDateTime } = req.body;

    // تحقق من وجود البيانات المطلوبة
    if (!needyId || !appointmentDateTime) {
      return res
        .status(400)
        .json({ error: 'يرجى إدخال جميع البيانات المطلوبة' });
    }

    // إنشاء وحفظ الموعد في قاعدة البيانات
    const newAppointment = new Appointment({
      needyId,
      appointmentDateTime,
    });

    await newAppointment.save();
    res.status(200).json({ message: 'تم تحديد الموعد بنجاح' });
  } catch (error) {
    res
      .status(500)
      .json({ error: 'حدث خطأ أثناء تحديد الموعد', details: error.message });
  }
});
module.exports = router; 