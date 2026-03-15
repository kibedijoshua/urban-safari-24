import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import '../theme/app_theme.dart';
import '../providers/market_provider.dart';
import '../models/models.dart';

class AddProductScreen extends StatefulWidget {
  final String? productId;
  const AddProductScreen({super.key, this.productId});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();
  String? _selectedStoreId;
  String? _selectedCategory;
  
  final List<String> _categories = ['clothing', 'shoes', 'caps', 'jerseys', 'boots', 'gadgets'];
  
  int _selectedSize = 0;
  int _selectedColor = 0;
  final _sizes = ['S', 'M', 'L', 'XL'];
  final _colors = [Colors.black, Colors.white, Colors.red, Colors.blue, Colors.green];

  XFile? _productImage;
  String? _existingImageUrl;
  bool _isSubmitting = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _loadProductData();
    }
  }

  Future<void> _loadProductData() async {
    setState(() => _isLoading = true);
    try {
      final market = context.read<MarketProvider>();
      final data = await market.getProductById(widget.productId!);
      if (data != null && mounted) {
        final product = Product.fromMap(data, widget.productId!);
        _nameController.text = product.name;
        _priceController.text = product.price.toString();
        _descController.text = product.description ?? '';
        _selectedStoreId = product.storeId;
        _selectedCategory = product.category;
        _existingImageUrl = product.imageUrl;
        
        // Match size/color if possible
        final sizeIdx = _sizes.indexOf(data['size'] ?? 'M');
        if (sizeIdx != -1) _selectedSize = sizeIdx;
        
        // Color matching logic could be more robust, keeping it simple for now
      }
    } catch (e) {
      debugPrint('Error loading product: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _productImage = image);
    }
  }

  Future<void> _submitProduct() async {
    if ((_productImage == null && _existingImageUrl == null) || 
        _nameController.text.isEmpty || 
        _priceController.text.isEmpty || 
        _selectedStoreId == null ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields and pick an image')));
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final market = context.read<MarketProvider>();
      
      // 1. Upload Image if new one picked
      String imageUrl = _existingImageUrl ?? '';
      if (_productImage != null) {
        imageUrl = await market.uploadProductImage(_productImage!, _selectedStoreId!);
      }

      final productData = {
        'name': _nameController.text,
        'price': _priceController.text,
        'description': _descController.text,
        'storeId': _selectedStoreId,
        'category': _selectedCategory,
        'image': imageUrl,
        'imageUrl': imageUrl,
        'size': _sizes[_selectedSize],
        'color': _colors[_selectedColor].value.toString(),
      };

      // 2. Add or Update Product
      if (widget.productId != null) {
        await market.updateProduct(widget.productId!, productData);
      } else {
        await market.addProduct(productData);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.productId != null ? 'Product updated successfully! ✅' : 'Product listed successfully! ✅'), 
            backgroundColor: AppColors.primary, 
            behavior: SnackBarBehavior.floating
          )
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(backgroundColor: AppColors.backgroundDark, body: Center(child: CircularProgressIndicator()));
    }

    final market = context.watch<MarketProvider>();
    final stores = market.allStores;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back, color: AppColors.primary), onPressed: () => context.pop()),
              Expanded(child: Text(widget.productId != null ? 'Edit Product' : 'Post New Item', textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(width: 48),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Image Picker
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200, width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                      image: (_productImage != null || _existingImageUrl != null)
                        ? DecorationImage(
                            image: _productImage != null 
                              ? (kIsWeb ? NetworkImage(_productImage!.path) : FileImage(File(_productImage!.path)) as ImageProvider)
                              : NetworkImage(_existingImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                    ),
                    child: (_productImage == null && _existingImageUrl == null)
                      ? Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                          Icon(Icons.add_a_photo_outlined, color: AppColors.primary, size: 40),
                          SizedBox(height: 12),
                          Text('Add Product Photo', style: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.bold)),
                        ])
                      : Container(
                          decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(20)),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                  ),
                ),

                const SizedBox(height: 24),
                
                // Form
                const Text('Product Title', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(hintText: 'e.g. Vintage Silk Kimono'),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                const Text('Price (UGX)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'e.g. 150000'),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                const Text('Target Store', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedStoreId,
                  dropdownColor: const Color(0xFF1E293B),
                  hint: const Text('Select which store to list under'),
                  items: stores.map((s) => DropdownMenuItem(value: s['id'] as String, child: Text(s['name'] as String))).toList(),
                  onChanged: (v) => setState(() => _selectedStoreId = v),
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                const Text('Product Category', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  dropdownColor: const Color(0xFF1E293B),
                  hint: const Text('Select a category (e.g. clothing, shoes)'),
                  items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _selectedCategory = v),
                  decoration: const InputDecoration(contentPadding: EdgeInsets.symmetric(horizontal: 12)),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 20),
                const Text('Description', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 8),
                TextField(
                  controller: _descController,
                  maxLines: 4,
                  decoration: const InputDecoration(hintText: 'Describe the fabric, fit, and unique features...'),
                  style: const TextStyle(color: Colors.white),
                ),

                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: _isSubmitting ? null : _submitProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmitting ? Colors.grey : AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isSubmitting 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.productId != null ? 'Update Product' : 'List Product', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}
