const express = require('express');
const Appointment = require('../models/appointments');
const User = require('../models/user.model');
const router = express.Router();
const mongoose = require('mongoose');
const BloodRequest = require('../models/bloodRequest.model');
const DonationRequest = require('../models/donationRequest');
router.post('/appointments', async (req, res) => {
  try {
    const {
      donorReqId,
      donorname,
      needyname,
      needyReqId,
      donorId,
      needyId,
      appointmentDateTime,
      status,
    } = req.body;

    if (
      !donorReqId ||
      !donorname ||
      !needyname ||
      !needyReqId ||
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

    const newAppointment = new Appointment({
      needyReqId,
      donorReqId,
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

router.get('/View-appointments-assigned', async (req, res) => {
  try {
    const Appointments = await Appointment.find({
      status: 'assigned',
    });
    res.status(200).json(Appointments);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
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
router.put('/appointments-status/:id', async (req, res) => {
  const { id } = req.params; // معرف الموعد
  const { status, donorReqId, needyReqId } = req.body; // البيانات المرسلة مع الطلب

  try {
    // تحديث حالة طلب التبرع
    const updatedDonationRequest = await DonationRequest.findByIdAndUpdate(
      donorReqId,
      { requestStatus: status },
      { new: true }
    );

    // تحديث حالة طلب الدم
    const updatedBloodRequest = await BloodRequest.findByIdAndUpdate(
      needyReqId,
      { requestStatus: status },
      { new: true }
    );

    // تحديث حالة الموعد
    const updatedAppointment = await Appointment.findByIdAndUpdate(
      id,
      { status },
      { new: true }
    );

    // التحقق من وجود السجلات
    if (!updatedAppointment) {
      return res.status(404).json({ message: 'Appointment not found' });
    }
    if (!updatedDonationRequest) {
      return res.status(404).json({ message: 'Donation request not found' });
    }
    if (!updatedBloodRequest) {
      return res.status(404).json({ message: 'Blood request not found' });
    }

    // إرسال استجابة النجاح
    res.json({
      message: 'Status updated successfully',
      appointment: updatedAppointment,
      donationRequest: updatedDonationRequest,
      bloodRequest: updatedBloodRequest,
    });
  } catch (error) {
    // التعامل مع الأخطاء
    res.status(500).json({ message: 'Error updating status', error });
  }
});

router.post('/donation-count', async (req, res) => {
  try {
    const { userId } = req.body;

    // التحقق من وجود userId
    if (!userId) {
      return res.status(400).json({ error: 'User ID is required' });
    }

    if (!mongoose.Types.ObjectId.isValid(userId)) {
      return res.status(400).json({ error: 'Invalid User ID' });
    }

    const [requestCount, userInfo] = await Promise.all([
      Appointment.countDocuments({ donorId: userId, status: 'completed' }),
      User.findById(userId).select('firstName lastName email number'),
    ]);

    if (!userInfo) {
      return res.status(404).json({ error: 'User not found' });
    }

    const points = requestCount * 10;
    const certificate = requestCount >= 3;

    res.status(200).json({
      user: userInfo,
      donations: requestCount,
      points,
      certificate,
    });
  } catch (error) {
    console.error('Error fetching donation count:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

module.exports = router;
