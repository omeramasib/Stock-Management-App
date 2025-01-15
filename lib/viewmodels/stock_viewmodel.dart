import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';
import '../services/database_services.dart';

class StockViewModel extends StateNotifier<List<Product>> {
  StockViewModel() : super([]);

  final DBService _database = DBService();
  List<Product> _allProducts = []; // Store all products from the database

  /// Load all products from the database
  Future<void> loadProducts() async {
    final dbProducts = await _database.queryAll('products');
    _allProducts = dbProducts.map((e) => Product.fromMap(e)).toList();
    state = [..._allProducts]; // Reflect the full product list in state
  }

  /// Apply a filter to the product list
  void applyFilter(bool Function(Product) filterCondition) {
    state = _allProducts.where(filterCondition).toList();
  }

  /// Add a new product
  Future<void> addProduct(Product product) async {
    final id = await _database.insert('products', product.toMap());
    final newProduct = product.copyWith(id: id);
    _allProducts.add(newProduct);
    state = [..._allProducts];
  }

  /// Update the stock of a product
  Future<void> updateStock(int id, int newStock) async {
    await _database.update('products', {'stock': newStock}, id);
    _allProducts = _allProducts.map((product) {
      return product.id == id ? product.copyWith(stock: newStock) : product;
    }).toList();
    state = [..._allProducts]; // Reflect updates in the state
  }
}

final stockViewModelProvider =
    StateNotifierProvider<StockViewModel, List<Product>>((ref) {
  final viewModel = StockViewModel();
  viewModel.loadProducts(); // Automatically load products at initialization
  return viewModel;
});

