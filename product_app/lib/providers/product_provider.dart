import 'package:flutter/material.dart';
import 'package:product_app/services/api_services.dart';
import 'package:product_app/models/product.dart';

class ProductProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];

  List<Product> get products => _products;

  // Fetch 
  Future<void> fetchProducts() async {
    try {
      _products = await _apiService.fetchProducts();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Add 
  Future<void> addProduct(Product product) async {
    try {
      await _apiService.addProduct(product);
      await fetchProducts(); // Refresh list
    } catch (error) {
      rethrow;
    }
  }

  // Update
  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await _apiService.updateProduct(id, newProduct);
      await fetchProducts(); // Refresh list
    } catch (error) {
      rethrow;
    }
  }

  // Delete 
  Future<void> deleteProduct(String id) async {
    try {
      await _apiService.deleteProduct(id);
      _products.removeWhere((product) => product.id == id);
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  // Sort products 
  void sortProductsByPrice({bool ascending = true}) {
    _products.sort((a, b) =>
        ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price));
    notifyListeners();
  }
}
