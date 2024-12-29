const express = require('express');
const Appointment = require('../models/appointments');
const router = express.Router();
router.post('/appointments', async (req, res) => {
  try {
    const {
      donorname,
      needyname,
      donorId,
      needyId,
      appointmentDateTime,
      status,
    } = req.body;

    // التحقق من وجود البيانات المطلوبة
    if (
      !donorname ||
      !needyname ||
      !donorId ||
      !needyId ||
      !appointmentDateTime ||
      !status
    ) {
      return res.status(400).json({
        error: 'يرجى إدخال جميع البيانات المطلوبة',
        missingFields: {
          donorname: !!donorname,
          needyname: !!needyname,
          donorId: !!donorId,
          needyId: !!needyId,
          appointmentDateTime: !!appointmentDateTime,
          status: !!status,
        },
      });
    }

    // إنشاء وحفظ الموعد في قاعدة البيانات
    const newAppointment = new Appointment({
      donorId,
      donorname,
      needyId,
      needyname,
      appointmentDateTime,
      status,
    });

    await newAppointment.save();

    res
      .status(200)
      .json({ message: 'تم تحديد الموعد بنجاح', appointment: newAppointment });
  } catch (error) {
    console.error('Error saving appointment:', error);
    res.status(500).json({
      error: 'حدث خطأ أثناء تحديد الموعد',
      details: error.message,
    });
  }
});

router.put('/appointments-notes/:id', async (req, res) => {
  try {
    const appointmentId = req.params.id;
    const { notes } = req.body;

    if (!notes) {
      return res
        .status(400)
        .json({ error: 'يرجى إدخال جميع البيانات المطلوبة' });
    }

    const updatedAppointment = await Appointment.findByIdAndUpdate(
      appointmentId,
      { notes },
      { new: true }
    );

    if (!updatedAppointment) {
      return res.status(404).json({ error: 'لم يتم العثور على الموعد' });
    }

    res
      .status(200)
      .json({ message: 'تم تحديث الملاحظات بنجاح', updatedAppointment });
  } catch (error) {
    res
      .status(500)
      .json({ error: 'حدث خطأ أثناء تحديث الملاحظة', details: error.message });
  }
});

router.get('/View-appointments', async (req, res) => {
  try {
    const Appointments = await Appointment.find({
      status:'assigned',
    });
    res.status(200).json(Appointments);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.put('/appointments-status/:id', async (req, res) => {
  const { id } = req.params;
  const { status } = req.body;

  try {
    const updatedAppointment = await Appointment.findByIdAndUpdate(
      id,
      { status },
      { new: true } // Return the updated document
    );

    if (!updatedAppointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }

    res.json({
      message: 'Status updated successfully',
      appointment: updatedAppointment,
    });
  } catch (error) {
    res.status(500).json({ message: 'Error updating status', error });
  }
});
module.exports = router;
