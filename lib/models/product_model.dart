class Product {
  final int? id;
  final String name;
  final int stock;
  final double price;

  Product({
    this.id,
    required this.name,
    required this.stock,
    required this.price,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      stock: map['stock'],
      price: map['price'],
    );
  }

  Product copyWith({int? stock}) {
    return Product(
      id: id,
      name: name,
      stock: stock ?? this.stock,
      price: price,
    );
  }
}