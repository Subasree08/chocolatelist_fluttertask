const express = require('express');
const { createProduct, getAllProducts, getProduct, updateProduct, deleteProduct } = require('../controllers/productController');

const router = express.Router();

// Routes
router.post('/create', createProduct);  // Create product
router.get('/', getAllProducts); // Get all products
router.get('/:id', getProduct); // Get a single product
router.put('/:id', updateProduct); // Update product
router.delete('/:id', deleteProduct); // Delete product

module.exports = router;
