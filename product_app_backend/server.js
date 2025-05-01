const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
const productRoutes = require('./routes/productRoutes');

const app = express();

// Middleware
app.use(express.json());
app.use(cors());

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// MongoDB connection
mongoose.connect('mongodb://localhost:27017/product_app')
   .then(() => {
       console.log('MongoDB connected');
       app.listen(5000, () => {
           console.log('Server running on port 5000');
       });
   })
   .catch(err => console.log('MongoDB connection error:', err));

// Routes
app.use('/api/products', productRoutes);
