const express = require('express');
const BloodRequest = require('../models/bloodRequest.model');
const donationRequest = require('../models/donationRequest');
const multer = require('multer');
const path = require('path');
const User = require('../models/user.model');
const Image = require('../models/Image');
const router = express.Router();

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, '../frontend/assets/externalreport');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});
const donation = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, '../frontend/assets/donationreport');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});
const upload = multer({ storage: storage });
const upload_donation_repo = multer({ storage: donation });
router.use('/uploads', express.static(path.join(__dirname, 'uploads')));
router.post(
  '/blood-request/external',
  upload.single('image'),
  async (req, res) => {
    try {
      const { location, bloodType, urgencyLevel, userId } = req.body;

      if (!location || !bloodType || !urgencyLevel || !userId) {
        return res.status(400).json({ message: 'All fields are required' });
      }

      const user = await User.findById(userId);

      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      if (user.role === 'user' && !req.file) {
        return res.status(400).json({ message: 'Image is required for users' });
      }

      const requestType =
        user.role === 'doctor'
          ? 'internal'
          : user.role === 'user'
          ? 'external'
          : 'unknown';

      const bloodRequest = new BloodRequest({
        medecalreport: req.file
          ? `assets/externalreport/${req.file.filename}`
          : null,
        location,
        bloodType,
        urgencyLevel,
        requestneedytype: requestType,
        createdAt: Date.now(),
        user: userId,
      });

      let image;
      if (req.file) {
        image = new Image({
          filePath: `assets/externalreport/${req.file.filename}`,
        });
        await image.save();
        user.images.push(image._id);
      }

      await bloodRequest.save();
      await user.save();
      const userResponse = {
        medecalreport: bloodRequest.medecalreport,
        location: bloodRequest.location,
        bloodType: bloodRequest.bloodType,
        urgencyLevel: bloodRequest.urgencyLevel,
        requestneedytype: bloodRequest.requestneedytype,
        createdAt: bloodRequest.createdAt,
        user_id: bloodRequest.user,
        status: bloodRequest.requestStatus,
      };

      return res.status(201).json({
        message: 'Blood request created successfully',
        userResponse,
      });
    } catch (err) {
      console.error(err.message);
      return res.status(500).json({
        error: 'An error occurred while creating the blood request',
      });
    }
  }
);

router.post(
  '/donation-Request',
  upload_donation_repo.single('image'),
  async (req, res) => {
    try {
      console.log(req.file);
      console.log(req.files);
      console.log(req.body);
      const { location, Weight, bloodType, AvailabilityPeriod, userId } =
        req.body;

      if (
        !location ||
        !Weight ||
        !bloodType ||
        !AvailabilityPeriod ||
        !userId
      ) {
        return res.status(400).json({ message: 'All fields are required' });
      } else if (!req.file) {
        console.log(res.statusCode);
        return res.status(400).json({ message: 'image is required' });
      }

      const image = new Image({
        filePath: `assets/donationreport/${req.file.filename}`,
      });

      const DonationRequest = new donationRequest({
        medecalreport: req.file
          ? `assets/donationreport/${req.file.filename}`
          : null,
        Weight,
        location,
        bloodType,
        AvailabilityPeriod,
        createdAt: Date.now(),
        user: userId,
      });

      await DonationRequest.save();
      await image.save();

      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      user.images.push(image._id);
      await user.save();
      if (req.file) {
        console.log(res.statusCode);
        return res.status(201).json({
          message: 'Blood request created and image added to user',
          DonationRequest,
        });
      }
    } catch (err) {
      console.error(err.message);
      return res
        .status(500)
        .json({ error: 'An error occurred while creating the blood request' });
      console.log(res.statusCode);
    }
  }
);
router.get('/blood-requests', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find();
    res.json(bloodRequests);
    console.log(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/blood-requests/external', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find({
      requestneedytype: 'external',
      requestStatus: 'active',
    });
    res.json(bloodRequests);
    console.log(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/blood-requests/approve', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find({
      requestneedytype: 'external',
      requestStatus: 'approved',
    });
    res.json(bloodRequests);
    console.log(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/blood-requests/enternal', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find({
      requestneedytype: 'internal',
    });
    res.json(bloodRequests);
    console.log(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/donation-request', async (req, res) => {
  try {
    const donationrequest = await donationRequest.find({
      requestStatus: 'active',
    });
    res.json(donationrequest);
    console.log(donationrequest);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
router.get('/donation-request-approved', async (req, res) => {
  try {
    const donationrequest = await donationRequest.find({
      requestStatus: 'approved',
    });
    res.json(donationrequest);
    console.log(donationrequest);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});

router.get('/requestImage/:userId/', async (req, res) => {
  try {
    const { userId } = req.params;

    const user = await User.findById(userId).populate('images');

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    if (!user.images || user.images.length === 0) {
      return res.status(404).json({ message: 'No images found for this user' });
    }

    const imagePaths = user.images.map((image) => image.filePath);
    res.status(200).json({ images: imagePaths });
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching user images' });
  }
});
router.put('/update-status', async (req, res) => {
  const { requestId, requestStatus } = req.body;

  if (!requestId || !requestStatus) {
    return res.status(400).json({ error: 'يجب إدخال requestId و status' });
  }

  try {
    const updatedRequest = await BloodRequest.findByIdAndUpdate(
      requestId,
      { requestStatus },
      { new: true }
    );

    if (!updatedRequest) {
      return res.status(404).json({ error: 'الطلب غير موجود' });
    }

    res.status(200).json({
      message: 'تم تحديث الحالة بنجاح',
      updatedRequest,
    });
  } catch (error) {
    console.error('Error updating request:', error);
    res.status(500).json({ error: 'حدث خطأ أثناء تحديث الحالة' });
  }
});
router.put('/update-status-donation', async (req, res) => {
  const { requestId, requestStatus } = req.body;

  if (!requestId || !requestStatus) {
    return res.status(400).json({ error: 'يجب إدخال requestId و status' });
  }

  try {
    const updatedRequest = await donationRequest.findByIdAndUpdate(
      requestId,
      { requestStatus },
      { new: true }
    );

    if (!updatedRequest) {
      return res.status(404).json({ error: 'الطلب غير موجود' });
    }

    res.status(200).json({
      message: 'تم تحديث الحالة بنجاح',
      updatedRequest,
    });
  } catch (error) {
    console.error('Error updating request:', error);
    res.status(500).json({ error: 'حدث خطأ أثناء تحديث الحالة' });
  }
});
router.get('/blood-requests-with-user', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find()
      .select('urgencyLevel user')
      .populate('user', 'firstName')
      .sort({ urgencyLevel: 1 }) // تضمين الحقل firstName من جدول User
      .exec();

    res.status(200).json(bloodRequests);
  } catch (err) {
    console.error(err);
    res
      .status(500)
      .json({ error: 'An error occurred while fetching blood requests' });
  }
});
module.exports = router;
