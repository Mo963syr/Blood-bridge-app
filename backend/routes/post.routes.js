const express = require('express');
const Posts = require('../models/Posts');
const router = express.Router();

router.post('/create-post', async (req, res) => {
  try {
    const { title, content, userId } = req.body;

    if (!title || !content || !userId) {
      return res.status(400).json({ message: 'All fields are required' });
    }

    const newPost = new Posts({
      title,
      content,
      userId,
    });

    await newPost.save();

    return res
      .status(201)
      .json({ message: 'Post created successfully', post: newPost });
  } catch (err) {
    console.error(err.message);
    return res
      .status(500)
      .json({ error: 'An error occurred while creating the post' });
  }
});
router.get('/posts', async (req, res) => {
    try {
      const post = await Posts.find();
      res.json(post);
      console.log(post);
    } catch (err) {
      console.error(err);
      res
        .status(500)
        .json({ error: 'An error occurred while fetching blood requests' });
    }
  });

module.exports = router;
