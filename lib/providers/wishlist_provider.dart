import 'package:flutter/material.dart';
import '../models/models.dart';

class WishlistProvider extends ChangeNotifier {
  final List<Product> _favoriteItems = [];

  List<Product> get favoriteItems => _favoriteItems;

  bool isFavorite(String productId) {
    return _favoriteItems.any((p) => p.id == productId);
  }

  void toggleFavorite(Product product) {
    final index = _favoriteItems.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _favoriteItems.removeAt(index);
    } else {
      _favoriteItems.add(product);
    }
    notifyListeners();
  }
}
