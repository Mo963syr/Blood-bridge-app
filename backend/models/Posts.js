const mongoose = require('mongoose');
const dayjs = require('dayjs');
const Schema = mongoose.Schema;

const PostSchema = new Schema({
  title: { type: String, required: true },
  content: { type: String, required: true },
  userId: { type: String, required: true },
  createdAt: {
    type: Date,
    default: Date.now,
    get: (timestamp) =>
      dayjs(timestamp).format('YYYY-MM-DD'),
  },
  time: {
    type: Date,
    default: Date.now,
    get: (timestamp) =>
      dayjs(timestamp).format('HH:mm:ss'),
  },
});

PostSchema.set('toJSON', { getters: true });
PostSchema.set('toObject', { getters: true });

module.exports = mongoose.model('Posts', PostSchema);
