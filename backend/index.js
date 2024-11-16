const express = require('express');
const mongoose = require('mongoose');
const bloodRequestRoutes = require('./routes/bloodRequest.routes');
const authRoutes = require('./routes/auth');
const app = express();
app.use(express.json());

const port = 8080 || process.env.PORT;
const cors = require('cors');
const bodyParser = require('body-parser');

mongoose
  .connect('mongodb://localhost:27017/bloodBridge', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => {
    console.log('Connected to MongoDB!');
  })
  .catch((err) => {
    console.error('Error connecting to MongoDB:', err);
  });

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/', require('./routes/user.route'));
app.use('/api/auth', authRoutes);
app.use('/api', bloodRequestRoutes);
app.listen(port,'0.0.0.0', () => {
  console.log('port running on ' + port);
});
