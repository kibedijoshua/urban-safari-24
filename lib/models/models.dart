class User {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
  });
}

class Product {
  final String id;
  final String brand;
  final String name;
  final int price;
  final int? originalPrice;
  final String imageUrl;
  final String? badge;
  final double rating;
  final int reviewCount;
  final String? description;
  final String? storeId;
  final String? category;
  final DateTime? createdAt;

  const Product({
    required this.id,
    required this.brand,
    required this.name,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    this.badge,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.description,
    this.storeId,
    this.category,
    this.createdAt,
  });

  factory Product.fromMap(Map<String, dynamic> map, String id) {
    return Product(
      id: id,
      brand: map['brand'] as String? ?? 'Aura',
      name: map['name'] as String? ?? 'Untitled Product',
      price: int.tryParse(map['price']?.toString() ?? '0') ?? 0,
      originalPrice: map['originalPrice'] != null ? int.tryParse(map['originalPrice'].toString()) : null,
      imageUrl: (map['imageUrl'] as String? ?? map['image'] as String? ?? ''),
      badge: map['badge'] as String?,
      rating: double.tryParse(map['rating']?.toString() ?? '4.5') ?? 4.5,
      reviewCount: int.tryParse(map['reviewCount']?.toString() ?? '0') ?? 0,
      description: map['description'] as String?,
      storeId: map['storeId'] as String?,
      category: map['category'] as String?,
      createdAt: map['createdAt'] != null 
          ? (map['createdAt'] is DateTime 
              ? map['createdAt'] as DateTime 
              : (map['createdAt'] as dynamic).toDate()) 
          : null,
    );
  }
}

class CartItem {
  final Product product;
  int quantity;
  final String selectedSize;
  final String selectedColor;

  CartItem({
    required this.product,
    this.quantity = 1,
    this.selectedSize = 'M',
    this.selectedColor = 'Black',
  });
}
