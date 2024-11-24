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

      if (!location || !bloodType || !urgencyLevel || !req.file || !userId) {
        return res.status(400).json({ message: 'All fields are required' });
      }

      const image = new Image({
        filePath: `/uploads/${req.file.filename}`,
      });

      const bloodRequest = new BloodRequest({
        medecalreport: image._id,
        location,
        bloodType,
        urgencyLevel,
        requestneedytype: 'external',
        createdAt: Date.now(),
        user: userId,
      });
      const userResponse = {
        medecalreport: bloodRequest.medecalreport,
        location: bloodRequest.location,
        bloodType: bloodRequest.bloodType,
        urgencyLevel: bloodRequest.urgencyLevel,
        requestneedytype: 'external',
        createdAt: Date.now(),
        user: bloodRequest.user,
        status: bloodRequest.requestStatus,
      };

      await bloodRequest.save();
      await image.save();

      const user = await User.findById(userId);
      if (!user) {
        return res.status(404).json({ message: 'User not found' });
      }

      user.images.push(image._id);
      await user.save();

      return res.status(201).json({
        message: 'Blood request created and image added to user',
        bloodRequest,
      });
    } catch (err) {
      console.error(err.message);
      return res
        .status(500)
        .json({ error: 'An error occurred while creating the blood request' });
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

  
    if (
      !location ||
      !Weight ||
      !bloodType ||
      !AvailabilityPeriod ||
      !req.file ||
      !userId
    ) {
      return res.status(400).json({ message: 'All fields are required' });
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

    return res.status(201).json({
      message: 'Blood request created and image added to user',
      DonationRequest,
    });
  } catch (err) {
    console.error(err.message);
    return res
      .status(500)
      .json({ error: 'An error occurred while creating the blood request' });
  }
});
router.get('/blood-requests', async (req, res) => {
  try {
    const bloodRequests = await BloodRequest.find();
    res.json(bloodRequests);
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
