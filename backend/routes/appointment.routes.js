const express = require('express');
const Appointment = require('../models/appointments');
const router = express.Router();
router.post('/appointments', async (req, res) => {
  try {
    const { donorname, needyname, donorId, needyId, appointmentDateTime } =
      req.body;

    // تحقق من وجود البيانات المطلوبة
    if (
      !donorname ||
      !needyname ||
      !donorId ||
      !needyId ||
      !appointmentDateTime
    ) {
      return res
        .status(400)
        .json({ error: 'يرجى إدخال جميع البيانات المطلوبة' });
    }

    // إنشاء وحفظ الموعد في قاعدة البيانات
    const newAppointment = new Appointment({
      donorId,
      donorname,
      needyId,
      needyname,
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

router.get('/View-appointments', async (req, res) => {
  try {
    const Appointments = await Appointment.find();
    res.status(200).json(Appointments);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
module.exports = router;
