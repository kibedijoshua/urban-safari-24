import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Markets & Categories
  Stream<List<Map<String, dynamic>>> getCategories() {
    return _db.collection('categories').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        }).toList());
  }

  // Stores
  Stream<List<Map<String, dynamic>>> getStores() {
    return _db.collection('stores').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        }).toList());
  }

  Stream<List<Map<String, dynamic>>> getStoresByCategory(String categoryName) {
    if (categoryName == 'All') return getStores(); // Fallback for safety during transition
    return _db.collection('stores').where('category', isEqualTo: categoryName).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        }).toList());
  }

  // Individual Store Info
  Future<Map<String, dynamic>?> getStoreById(String storeId) async {
    final doc = await _db.collection('stores').doc(storeId).get();
    if (doc.exists) {
      return {
        ...(doc.data() as Map<String, dynamic>),
        'id': doc.id,
      };
    }
    return null;
  }

  // Products
  Stream<List<Map<String, dynamic>>> getStoreProducts(String storeId) {
    return _db.collection('products').where('storeId', isEqualTo: storeId).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        }).toList());
  }

  Future<Map<String, dynamic>?> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (!doc.exists) return null;
    return {
      ...(doc.data() as Map<String, dynamic>),
      'id': doc.id,
    };
  }

  Stream<List<Map<String, dynamic>>> getAllProducts() {
    return _db.collection('products').orderBy('createdAt', descending: true).snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {
          ...(doc.data() as Map<String, dynamic>),
          'id': doc.id,
        }).toList());
  }

  // Admin Actions
  Future<void> addProduct(Map<String, dynamic> productData) async {
    final storeId = productData['storeId'];
    
    await _db.runTransaction((transaction) async {
      // 1. Add product
      final productRef = _db.collection('products').doc();
      transaction.set(productRef, {
        ...productData,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // 2. Increment store itemsCount
      if (storeId != null) {
        final storeRef = _db.collection('stores').doc(storeId);
        transaction.update(storeRef, {
          'itemsCount': FieldValue.increment(1),
        });
      }
    });
  }

  Future<void> createStore(Map<String, dynamic> storeData) async {
    await _db.collection('stores').add({
      ...storeData,
      'rating': 5.0,
      'itemsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> productData) async {
    await _db.collection('products').doc(productId).update({
      ...productData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteProduct(String productId) async {
    final doc = await _db.collection('products').doc(productId).get();
    final storeId = doc.data()?['storeId'];

    await _db.runTransaction((transaction) async {
      // 1. Delete product
      transaction.delete(_db.collection('products').doc(productId));

      // 2. Decrement store itemsCount
      if (storeId != null) {
        final storeRef = _db.collection('stores').doc(storeId);
        transaction.update(storeRef, {
          'itemsCount': FieldValue.increment(-1),
        });
      }
    });
  }

  Future<void> updateStore(String storeId, Map<String, dynamic> storeData) async {
    await _db.collection('stores').doc(storeId).update({
      ...storeData,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteStore(String storeId) async {
    // Note: In a production app, you might also want to delete all products belonging to this store.
    await _db.collection('stores').doc(storeId).delete();
    
    // Deleting associated products
    final products = await _db.collection('products').where('storeId', isEqualTo: storeId).get();
    for (var doc in products.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> clearCategories() async {
    final snapshot = await _db.collection('categories').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> recalculateItemsCount(String storeId) async {
    final products = await _db.collection('products').where('storeId', isEqualTo: storeId).get();
    final count = products.docs.length;
    await _db.collection('stores').doc(storeId).update({'itemsCount': count});
  }

  Future<void> seedInitialData() async {
    // 1. Categories
    final categories = ['clothing', 'shoes', 'caps', 'jerseys', 'boots', 'gadgets'];
    for (var cat in categories) {
      await _db.collection('categories').doc(cat).set({'name': cat});
    }

    // 2. Initial Store: Clothing and Kicks
    final storeRef = _db.collection('stores').doc('clothing-and-kicks');
    await storeRef.set({
      'name': 'Clothing and Kicks',
      'category': 'clothing',
      'specialty': 'Premium Sneakers & Urban Apparel',
      'rating': 4.9,
      'itemsCount': 0,
      'image': 'https://images.unsplash.com/photo-1552346154-21d32810aba3?q=80&w=2070&auto=format&fit=crop', // Trendy sneakers placeholder
    });
  }
}
