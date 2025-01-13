import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/main_screen.dart'; // Replace with your actual MainScreen file path

void main() {
  runApp(const ProviderScope(child: ProductStockManagementApp()));
}

class ProductStockManagementApp extends StatelessWidget {
  const ProductStockManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Stock Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MainScreen(),
    );
  }
}
