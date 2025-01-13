import '../models/product_model.dart';
import '../services/database_services.dart';

class StockRepository {
  final DBService dbService = DBService();

  Future<List<Product>> getProducts() async {
    final data = await dbService.queryAll('products');
    return data.map((e) => Product.fromMap(e)).toList();
  }

  Future<void> addProduct(Product product) async {
    await dbService.insert('products', product.toMap());
  }

  Future<void> updateStock(int id, int newStock) async {
    await dbService.update('products', id, {'stock': newStock});
  }

  Future<void> deleteProduct(int id) async {
    await dbService.delete('products', id);
  }
}