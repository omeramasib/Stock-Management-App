import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stock_management_app/services/database_services.dart';
import '../models/product_model.dart';

class StockViewModel extends StateNotifier<List<Product>> {
  StockViewModel() : super([]);

  final DBService database = DBService();
  List<Product> _allProducts = []; // Holds the original, unfiltered products
  void loadProducts() async {
    final dbProducts = await database.queryAll('products');
    final productList = dbProducts.map((e) => Product.fromMap(e)).toList();
    _allProducts = productList; // Cache the full product list
    state = productList; // Set the initial state
  }
  Future<void> addProduct(Product product) async {
    final id = await database.insert('products', product.toMap());
    final newProduct = product.copyWith(id: id);
    _allProducts = [..._allProducts, newProduct]; // Update the cache
    state = [...state, newProduct];
  }
  Future<void> updateProduct(Product product) async {
    await database.update('products', product.toMap(), product.id!);
    _allProducts = [
      for (final p in _allProducts)
        if (p.id == product.id) product else p
    ];
  }
  void applyFilter(bool Function(Product) filterCondition) {
    final filteredProducts = _allProducts.where(filterCondition).toList();
    log('Filtered Products: ${filteredProducts.map((p) => p.name).toList()}');
    state = filteredProducts;
  }

  void resetFilter() {
    state = _allProducts; // Reset to the cached full list
  }

  void updateStock(int id, int newStock) {
    database.update('products', {'stock': newStock}, id);
    _allProducts = [
      for (final product in _allProducts)
        if (product.id == id) product.copyWith(stock: newStock) else product
    ];
    state = [
      for (final product in state)
        if (product.id == id) product.copyWith(stock: newStock) else product
    ];
  }
}

// Provider for StockViewModel
final stockViewModelProvider =
    StateNotifierProvider<StockViewModel, List<Product>>((ref) {
  return StockViewModel();
});
