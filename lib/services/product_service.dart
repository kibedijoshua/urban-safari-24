import '../models/models.dart';

class ProductService {
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      brand: 'Aura',
      name: 'Kitenge Dress',
      price: 150000,
      imageUrl: 'https://images.unsplash.com/photo-1515347619362-e6fd8a7a8d5b',
    ),
    Product(
      id: '2',
      brand: 'Aura',
      name: 'Dashiki Shirt',
      price: 85000,
      imageUrl: 'https://images.unsplash.com/photo-1529631627581-30dcad26cba5',
    ),
    Product(
      id: '3',
      brand: 'Aura',
      name: 'Ankara Bag',
      price: 55000,
      imageUrl: 'https://images.unsplash.com/photo-1590874103328-eac38a683ce7',
    ),
  ];

  Stream<List<Product>> getProducts() {
    return Stream.value(_mockProducts);
  }

  Future<void> addProduct(Product product) async {
    _mockProducts.add(product);
  }

  // Admin: Initial Seeding
  Future<void> seedProducts(List<Product> products) async {
    _mockProducts.clear();
    _mockProducts.addAll(products);
  }
}
