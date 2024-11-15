const express = require('express');
const BloodRequest = require('../models/bloodRequest.model'); // تأكد من أن مسار الملف صحيح
const router = express.Router();

// إنشاء طلب حاجة للدم
router.post('/blood-request/external', async (req, res) => {
  const { location, bloodType, phoneNumber, urgencyLevel } = req.body;
  try {
    // التحقق من أن الحقول المطلوبة موجودة

    if (!location || !bloodType || !phoneNumber || !urgencyLevel) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // إنشاء طلب جديد للحاجة للدم
    const bloodRequest = new BloodRequest({
      location: req.body.location,
      bloodType: req.body.bloodType,
      phoneNumber: req.body.phoneNumber,
      urgencyLevel: req.body.urgencyLevel,
    
    });

    // حفظ الطلب في قاعدة البيانات
    await bloodRequest.save();
   return res.status(201).json({ message: 'Blood request created', bloodRequest });
    // الاستجابة مع تفاصيل الطلب المحفوظ
    res.json({
      message: 'Blood request created successfully',
      bloodRequest: {
        location: req.body.location,
        bloodType: req.body.bloodType,
        phoneNumber: req.body.phoneNumber,
        urgencyLevel: req.body.urgencyLevel,
      },
    });
  } catch (err) {
 return   res
      .status(500)
      .json({ error: 'An error occurred while creating the blood request' });
  }
});
router.post('/blood-request/enternal', async (req, res) => {
  const { location, bloodType, phoneNumber, urgencyLevel } = req.body;
  try {
    // التحقق من أن الحقول المطلوبة موجودة

    if (!location || !bloodType || !phoneNumber || !urgencyLevel) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    // إنشاء طلب جديد للحاجة للدم
    const bloodRequest = new BloodRequest({
      location: req.body.location,
      bloodType: req.body.bloodType,
      phoneNumber: req.body.phoneNumber,
      urgencyLevel: req.body.urgencyLevel,
      requestneedytype:'enternal'
    });

    // حفظ الطلب في قاعدة البيانات
    await bloodRequest.save();
   return res.status(201).json({ message: 'Blood request created', bloodRequest });
    // الاستجابة مع تفاصيل الطلب المحفوظ
    res.json({
      message: 'Blood request created successfully',
      bloodRequest: {
        location: req.body.location,
        bloodType: req.body.bloodType,
        phoneNumber: req.body.phoneNumber,
        urgencyLevel: req.body.urgencyLevel,
      },
    });
  } catch (err) {
 return   res
      .status(500)
      .json({ error: 'An error occurred while creating the blood request' });
  }
});

// جلب جميع طلبات الحاجة للدم
router.get('/blood-requests', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find();
    console.log(bloodRequests) 
    res.json(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/blood-requests/external', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find({ requestneedytype: 'external' });
    console.log(bloodRequests) 
    res.json(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});

module.exports = router;
