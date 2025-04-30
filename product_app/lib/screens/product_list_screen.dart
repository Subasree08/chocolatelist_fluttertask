import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/models/product.dart';
import 'package:product_app/providers/product_provider.dart';
import 'add_product_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    provider.fetchProducts().then((_) {
      setState(() {
        _filteredProducts = provider.products;
      });
    });

    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    final provider = Provider.of<ProductProvider>(context, listen: false);
    setState(() {
      _filteredProducts = provider.products.where((product) {
        return product.name.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 211, 82, 147), 
      appBar: AppBar(
        backgroundColor: Color.fromARGB(206, 192, 53, 157), 
        title: Text(
          'Chocolates', 
          style: GoogleFonts.poppins(
            fontSize: 24, 
            fontWeight: FontWeight.w700, 
            color: Colors.white, 
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            tooltip: 'Sort by price',
            icon: Icon(Icons.filter_alt),
            onSelected: (value) {
              if (value == 'asc') {
                productProvider.sortProductsByPrice(ascending: true);
              } else {
                productProvider.sortProductsByPrice(ascending: false);
              }
              _filterProducts();
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: 'asc', child: Text('Price: Low to High')),
              PopupMenuItem(value: 'desc', child: Text('Price: High to Low')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by product name...',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
          ),
          Expanded(
            child: _filteredProducts.isEmpty
                ? Center(child: Text('No products found'))
                : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: product.image.isNotEmpty
                              ? Image.network(
                                  product.image,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 60,
                                  height: 60,
                                  color: const Color.fromARGB(255, 74, 73, 177),
                                  child: Icon(Icons.image, size: 30),
                                ),
                          title: Text(
                            product.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(product.description),
                              Text('Price: ₹${product.price.toStringAsFixed(2)}'),

                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddProductScreen(product: product),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  productProvider.deleteProduct(product.id!);
                                  _filterProducts();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 98, 223, 216),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddProductScreen()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
