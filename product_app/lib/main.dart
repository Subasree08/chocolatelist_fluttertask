import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:product_app/providers/product_provider.dart';
import 'package:product_app/screens/product_list_screen.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product App',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
          useMaterial3: true,
        ),
        home: ProductListScreen(), 
      ),
    );
  }
}
