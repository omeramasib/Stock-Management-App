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

  Product copyWith({
    int? id,
    String? name,
    int? stock,
    double? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      stock: stock ?? this.stock,
      price: price ?? this.price,
    );
  }

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
      id: map['id'] as int?,
      name: map['name'] as String,
      stock: map['stock'] as int,
      price: map['price'] as double,
    );
  }
}