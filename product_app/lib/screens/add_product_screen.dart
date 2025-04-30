import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';
import '../services/api_services.dart';

class AddProductScreen extends StatefulWidget {
  final Product? product;

  AddProductScreen({this.product});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name, _description, _image;
  late double _price;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _description = widget.product?.description ?? '';
    _price = widget.product?.price ?? 0.0;
    _image = widget.product?.image ?? '';
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final product = Product(
        id: widget.product?.id,
        name: _name,
        description: _description,
        price: _price,
        image: _image,
      );

      final service = ApiService();
      final future = widget.product == null
          ? service.addProduct(product)
          : service.updateProduct(widget.product!.id!, product);

      future.then((_) => Navigator.pop(context)).catchError((err) => print(err));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 231, 143, 156), // Light pink shade for entire background
      appBar: AppBar(
        centerTitle: true, // Centers the title
        title: Text(
          widget.product == null ? 'Add Product' : 'Edit Product',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 207, 111, 126), // Light pink shade for the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (val) => _name = val!,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                initialValue: _description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (val) => _description = val!,
                validator: (val) => val!.isEmpty ? 'Enter description' : null,
              ),
              TextFormField(
                initialValue: _price.toString(),
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                onSaved: (val) => _price = double.tryParse(val!) ?? 0.0,
                validator: (val) => val!.isEmpty ? 'Enter price' : null,
              ),
              TextFormField(
                initialValue: _image,
                decoration: InputDecoration(labelText: 'Image URL'),
                onSaved: (val) => _image = val!,
                validator: (val) => val!.isEmpty ? 'Enter image URL' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 216, 108, 131), // Blue color for the button
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  widget.product == null ? 'Add Product' : 'Update Product',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
