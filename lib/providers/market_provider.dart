import '../services/firestore_service.dart';
import '../services/cloudinary_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show File;
import 'dart:async';

class MarketProvider extends ChangeNotifier {
  final FirestoreService _firestoreService = FirestoreService();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _stores = [];
  List<Map<String, dynamic>> _allStores = [];
  List<Map<String, dynamic>> _allProducts = [];
  String _currentCategory = 'clothing';
  bool _isLoading = false;
  
  StreamSubscription? _categoriesSub;
  StreamSubscription? _storesSub;
  StreamSubscription? _allStoresSub;
  StreamSubscription? _allProductsSub;

  List<Map<String, dynamic>> get categories => _categories;
  List<Map<String, dynamic>> get stores => _stores;
  List<Map<String, dynamic>> get allStores => _allStores;
  List<Map<String, dynamic>> get allProducts => _allProducts;
  bool get isLoading => _isLoading;

  MarketProvider() {
    _init();
  }

  void _init() {
    _isLoading = true;
    
    // Listen to categories
    _categoriesSub = _firestoreService.getCategories().listen((data) {
      _categories = data;
      _isLoading = false;
      notifyListeners();
    });

    // Listen to all stores with a stream that adapts to the current category
    _listenToStores();

    // Listen to ALL stores for admin dropdowns etc.
    _allStoresSub = _firestoreService.getStores().listen((data) {
      _allStores = data;
      notifyListeners();
    });

    // Listen to ALL products for Home and Shop screens
    _allProductsSub = _firestoreService.getAllProducts().listen((data) {
      _allProducts = data;
      notifyListeners();
    });
  }

  void _listenToStores() {
    _storesSub?.cancel();
    _storesSub = _firestoreService.getStores().listen((data) {
      _stores = data;
      _isLoading = false;
      notifyListeners();
    });
  }

  void filterStores(String categoryName) {
    // Categories are being removed from UI, keeping this as a no-op or simple setter
    if (_currentCategory == categoryName) return;
    _currentCategory = categoryName;
    // We stay fetching all stores for now
  }

  @override
  void dispose() {
    _categoriesSub?.cancel();
    _storesSub?.cancel();
    _allStoresSub?.cancel();
    _allProductsSub?.cancel();
    super.dispose();
  }

  // Helper for Product screen
  Stream<List<Map<String, dynamic>>> getStoreProducts(String storeId) {
    return _firestoreService.getStoreProducts(storeId);
  }

  Future<Map<String, dynamic>?> getStoreInfo(String storeId) {
    return _firestoreService.getStoreById(storeId);
  }

  Future<Map<String, dynamic>?> getProductById(String productId) {
    return _firestoreService.getProductById(productId);
  }

  Future<String> uploadProductImage(XFile xfile, String storeId) async {
    if (kIsWeb) {
      final bytes = await xfile.readAsBytes();
      return await _cloudinaryService.uploadImageBytes(bytes);
    } else {
      return await _cloudinaryService.uploadImage(File(xfile.path));
    }
  }

  Future<String> uploadStoreImage(XFile xfile, String type) async {
    if (kIsWeb) {
      final bytes = await xfile.readAsBytes();
      return await _cloudinaryService.uploadImageBytes(bytes);
    } else {
      return await _cloudinaryService.uploadImage(File(xfile.path));
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    await _firestoreService.addProduct(productData);
    notifyListeners();
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
    await _firestoreService.updateProduct(productId, productData);
    notifyListeners();
  }

  Future<void> deleteProduct(String productId) async {
    await _firestoreService.deleteProduct(productId);
    notifyListeners();
  }

  Future<void> createStore(Map<String, dynamic> storeData) async {
    await _firestoreService.createStore(storeData);
    notifyListeners();
  }

  Future<void> updateStore(String storeId, Map<String, dynamic> storeData) async {
    await _firestoreService.updateStore(storeId, storeData);
    notifyListeners();
  }

  Future<void> deleteStore(String storeId) async {
    await _firestoreService.deleteStore(storeId);
    notifyListeners();
  }

  Future<void> syncStoreStats(String storeId) async {
    await _firestoreService.recalculateItemsCount(storeId);
    notifyListeners();
  }

  String formatPrice(num price) {
    String value = price.toInt().toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return value.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }
}
