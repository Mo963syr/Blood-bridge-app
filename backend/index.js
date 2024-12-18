const express = require('express');
const dotenv = require('dotenv');
const cors = require('cors');
const bodyParser = require('body-parser');
const connectDB = require('./config/db');

dotenv.config();

const app = express();
const port = process.env.PORT || 8080;

connectDB();

app.use(cors());
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
app.use('/uploads', express.static('uploads')); 

const authRoutes = require('./routes/auth.routes');
const userRoutes = require('./routes/user.routes');
const bloodRequestRoutes = require('./routes/bloodRequest.routes');
const uploadRoutes = require('./routes/upload.routes');
const appointmentRoutes = require('./routes/appointment.routes');


app.use('/api/auth', authRoutes);
app.use('/api/users', userRoutes);
app.use('/api/requests', bloodRequestRoutes);
app.use('/api/uploads', uploadRoutes);
app.use('/api', appointmentRoutes);


app.listen(port,'0.0.0.0', () => {
  console.log(`Server running on port ${port}`);
});
