import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product_model.dart';

class StockViewModel extends StateNotifier<List<Product>> {
  StockViewModel() : super([]);

  // Add a product
  void addProduct(Product product) {
    state = [...state, product];
  }

  // Update stock for an existing product
  void updateStock(int productId, int newStock) {
    state = state.map((product) {
      if (product.id == productId) {
        return product.copyWith(stock: newStock);
      }
      return product;
    }).toList();
  }

  // Filter products based on a condition
  List<Product> filterProducts(bool Function(Product) condition) {
    return state.where(condition).toList();
  }
}

// Provider for StockViewModel
final stockViewModelProvider = StateNotifierProvider<StockViewModel, List<Product>>((ref) {
  return StockViewModel();
});

// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../models/product_model.dart';
// import '../repositories/stock_repository.dart';

// final stockViewModelProvider = StateNotifierProvider<StockViewModel, List<Product>>((ref) {
//   return StockViewModel();
// });

// class StockViewModel extends StateNotifier<List<Product>> {
//   final StockRepository repository = StockRepository();

//   StockViewModel() : super([]);

//   Future<void> fetchProducts() async {
//     state = await repository.getProducts();
//   }

//   Future<void> addProduct(Product product) async {
//     await repository.addProduct(product);
//     state = [...state, product];
//   }

//   Future<void> updateStock(int id, int quantity) async {
//     await repository.updateStock(id, quantity);
//     state = state.map((product) {
//       if (product.id == id) {
//         return product.copyWith(stock: quantity);
//       }
//       return product;
//     }).toList();
//   }

//   Future<void> removeProduct(int id) async {
//     await repository.deleteProduct(id);
//     state = state.where((product) => product.id != id).toList();
//   }
// }