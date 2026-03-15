import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/market_provider.dart';
import '../models/models.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;
  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _selectedColor = 0;
  int _selectedSize = 1;
  final List<Color> _colors = [const Color(0xFF1e1b4b), const Color(0xFF450a0a), const Color(0xFF064e3b), const Color(0xFF181611)];
  final List<String> _sizes = ['S', 'M', 'L', 'XL'];
  
  Product? _product;
  Map<String, dynamic>? _storeData;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final market = context.read<MarketProvider>();
      final data = await market.getProductById(widget.productId);
      if (mounted) {
        if (data != null) {
          final product = Product.fromMap(data, widget.productId);
          final storeInfo = product.storeId != null ? await market.getStoreInfo(product.storeId!) : null;
          setState(() {
            _product = product;
            _storeData = storeInfo;
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = "Product not found";
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null || _product == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error ?? 'Something went wrong', style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: () => context.pop(), child: const Text('Go Back')),
            ],
          ),
        ),
      );
    }

    final product = _product!;
    final cart = context.read<CartProvider>();
    final auth = context.read<AuthProvider>();
    final storePhone = _storeData?['phoneNumber'] as String? ?? '+256709397670';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Top nav
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withOpacity(0.9),
              border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1))),
            ),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.goNamed('shop');
                  }
                },
              ),
              const Expanded(child: Text('Product Details', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
              IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
            ]),
          ),
          // Scrollable body
          Expanded(
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Hero image
                Stack(children: [
                  SizedBox(
                    height: 420,
                    width: double.infinity,
                    child: Stack(children: [
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover, width: double.infinity, height: 420,
                        errorBuilder: (_, __, ___) => Container(
                          height: 420, color: AppColors.primary.withOpacity(0.1),
                          child: const Icon(Icons.image, size: 64, color: AppColors.primary)),
                      ),
                      Positioned.fill(child: DecoratedBox(
                        decoration: BoxDecoration(gradient: LinearGradient(
                          begin: Alignment.topCenter, end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        )),
                      )),
                    ]),
                  ),
                  Positioned(
                    right: 16, top: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, color: AppColors.primary),
                    ),
                  ),
                ]),

                Padding(padding: const EdgeInsets.all(16), child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_storeData?['name']?.toString().toUpperCase() ?? product.brand.toUpperCase(),
                    style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2)),
                  const SizedBox(height: 4),
                  Text(product.name,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white, height: 1.2)),
                  const SizedBox(height: 12),
                  Row(children: [
                    Text('${cart.formatPrice(product.price)} UGX', style: const TextStyle(color: AppColors.primary, fontSize: 22, fontWeight: FontWeight.w900)),
                    if (product.originalPrice != null) ...[
                      const SizedBox(width: 10),
                      Text('${cart.formatPrice(product.originalPrice!)} UGX', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 14, decoration: TextDecoration.lineThrough)),
                    ],
                  ]),

                  const SizedBox(height: 24),
                  const Text('PRODUCT DESCRIPTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
                  const SizedBox(height: 12),
                  Text(
                    (product.description != null && product.description!.isNotEmpty) 
                      ? product.description! 
                      : 'No description provided for this item by the seller.',
                    style: const TextStyle(color: Color(0xFF94A3B8), height: 1.6, fontSize: 14),
                  ),

                  // Color selector
                  const SizedBox(height: 24),
                  const Text('SELECT COLOR', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
                  const SizedBox(height: 12),
                  Row(children: List.generate(_colors.length, (i) => GestureDetector(
                    onTap: () => setState(() => _selectedColor = i),
                    child: Container(
                      width: 40, height: 40, margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: _colors[i], shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                        boxShadow: _selectedColor == i ? [BoxShadow(color: AppColors.primary, spreadRadius: 2, blurRadius: 0, offset: const Offset(0, 0))] : null,
                      ),
                    ),
                  ))),

                  // Size selector
                  const SizedBox(height: 24),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('SELECT SIZE', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
                    Text('Size Guide', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
                  ]),
                  const SizedBox(height: 12),
                  Row(children: List.generate(_sizes.length, (i) => Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedSize = i),
                      child: Container(
                        margin: EdgeInsets.only(right: i < _sizes.length - 1 ? 8 : 0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _selectedSize == i ? AppColors.primary : AppColors.primary.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _selectedSize == i ? AppColors.primary : AppColors.primary.withOpacity(0.2)),
                        ),
                        alignment: Alignment.center,
                        child: Text(_sizes[i], style: TextStyle(color: _selectedSize == i ? AppColors.backgroundDark : Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ))),

                  const SizedBox(height: 120), // Padding for bottom buttons
                ])),
              ]),
            ),
          ),
          
          // Bottom Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withOpacity(0.95),
              border: Border(top: BorderSide(color: const Color(0xFF1E293B))),
            ),
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  cart.addToCart(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart'), backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
                },
                child: Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.shopping_bag_outlined),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!auth.isLoggedIn) {
                      context.pushNamed('login');
                      return;
                    }
                    final Uri telUri = Uri(scheme: 'tel', path: storePhone.replaceAll(' ', ''));
                    try {
                      await launchUrl(telUri);
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Call Seller', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!auth.isLoggedIn) {
                      context.pushNamed('login');
                      return;
                    }
                    final String cleanPhone = storePhone.replaceAll('+', '').replaceAll(' ', '');
                    final String encodedMessage = Uri.encodeComponent('Hello, I want to buy ${product.name}');
                    final Uri whatsappUri = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMessage');
                    try {
                      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: const Text('WhatsApp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
