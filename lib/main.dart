import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'views/product_list_view.dart';

void main() {
  runApp(const ProviderScope(child: ProductStockManagementApp()));
}

class ProductStockManagementApp extends StatelessWidget {
  const ProductStockManagementApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product Stock Management',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProductListView(),
    );
  }
}
