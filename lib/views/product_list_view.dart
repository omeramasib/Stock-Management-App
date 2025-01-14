import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/stock_viewmodel.dart';
import '../models/product_model.dart';

class ProductListView extends ConsumerWidget {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(stockViewModelProvider.notifier).loadProducts();
    final products = ref.watch(stockViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Stock Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context, ref);
            },
          ),
        ],
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'No products available. Add some products!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock}'),
                  trailing: Text('\$${product.price.toStringAsFixed(2)}'),
                  onTap: () {
                    _showUpdateStockDialog(context, ref, product);
                  },
                );
              },
            ),
      // body: Consumer(
      //   builder: (context, ref, child) {
      //     final filteredProducts = ref.watch(stockViewModelProvider);

      //     if (filteredProducts.isEmpty) {
      //       return const Center(
      //         child: Text(
      //           'No products available. Add some products!',
      //           style: TextStyle(fontSize: 16),
      //         ),
      //       );
      //     }

      //     return ListView.builder(
      //       itemCount: filteredProducts.length,
      //       itemBuilder: (context, index) {
      //         final product = filteredProducts[index];
      //         return ListTile(
      //           title: Text(product.name),
      //           subtitle: Text('Stock: ${product.stock}'),
      //           trailing: Text('\$${product.price.toStringAsFixed(2)}'),
      //           onTap: () {
      //             _showUpdateStockDialog(context, ref, product);
      //           },
      //         );
      //       },
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddProductDialog(context, ref);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddProductDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final stockController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
              ),
              TextField(
                controller: stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final stock = int.tryParse(stockController.text.trim()) ?? 0;
                final price =
                    double.tryParse(priceController.text.trim()) ?? 0.0;

                if (name.isNotEmpty && stock >= 0 && price >= 0) {
                  final product =
                      Product(name: name, stock: stock, price: price);
                  ref.read(stockViewModelProvider.notifier).addProduct(product);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateStockDialog(
      BuildContext context, WidgetRef ref, Product product) {
    final stockController =
        TextEditingController(text: product.stock.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Stock: ${product.name}'),
          content: TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Stock Quantity'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final stock =
                    int.tryParse(stockController.text.trim()) ?? product.stock;
                ref
                    .read(stockViewModelProvider.notifier)
                    .updateStock(product.id!, stock);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showFilterOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('In Stock'),
              onTap: () {
                ref.read(stockViewModelProvider.notifier).applyFilter(
                      (product) => product.stock > 0,
                    );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Low Stock (< 10)'),
              onTap: () {
                ref.read(stockViewModelProvider.notifier).applyFilter(
                      (product) => product.stock > 0 && product.stock < 10,
                    );
                // ignore: invalid_use_of_protected_member
                log(ref
                    .read(stockViewModelProvider.notifier)
                    .state
                    .map((p) => p.name)
                    .toList()
                    .toString());
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Out of Stock'),
              onTap: () {
                ref.read(stockViewModelProvider.notifier).applyFilter(
                      (product) => product.stock == 0,
                    );
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: const Text('Reset Filter'),
              onTap: () {
                ref.read(stockViewModelProvider.notifier).resetFilter();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
