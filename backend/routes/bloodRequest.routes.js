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
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + '-' + file.originalname);
  },
});
const upload = multer({ storage: storage });

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
        medecalreport: req.file ? `/uploads/${req.file.filename}` : null,

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
          filePath: `/uploads/${req.file.filename}`,
        });
        await image.save();
        user.images.push(image._id);
      }

      await bloodRequest.save();
      await user.save();
      const userResponse = {
        medecalreport_id: bloodRequest.medecalreport,
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

router.post('/donation-Request', upload.single('image'), async (req, res) => {
  try {
    console.log(req.file);
    console.log(req.files);
    console.log(req.body);
    const { location, Weight, bloodType, AvailabilityPeriod, userId } =
      req.body;

    if (!location || !Weight || !bloodType || !AvailabilityPeriod || !userId) {
      return res.status(400).json({ message: 'All fields are required' });
    } else if (!req.file) {
      console.log(res.statusCode);
      return res.status(400).json({ message: 'image is required' });
    }

    const image = new Image({
      filePath: `/uploads/${req.file.filename}`,
    });

    const DonationRequest = new donationRequest({
      medecalreport: image._id,
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
});
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
    // فلترة الطلبات حسب النوع
    const bloodRequests = await BloodRequest.find({ requestneedytype: 'external' }); 
    res.json(bloodRequests);
    console.log(bloodRequests);
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

module.exports = router;
