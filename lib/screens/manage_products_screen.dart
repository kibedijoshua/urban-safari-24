import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/market_provider.dart';
import '../models/models.dart';

class ManageProductsScreen extends StatelessWidget {
  const ManageProductsScreen({super.key});

  String _formatPrice(num price) {
    String value = price.toInt().toString();
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    return value.replaceAllMapped(reg, (Match m) => '${m[1]},');
  }

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketProvider>();
    final productsData = market.allProducts;
    final products = productsData.map((p) => Product.fromMap(p, p['id'] as String)).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Manage Products', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: products.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inventory_2_outlined, color: AppColors.primary.withOpacity(0.3), size: 80),
                  const SizedBox(height: 16),
                  const Text('No products found', style: TextStyle(color: Colors.white60, fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('add-product'),
                    icon: const Icon(Icons.add),
                    label: const Text('Post Your First Product'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 56, height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(image: NetworkImage(product.imageUrl), fit: BoxFit.cover),
                      ),
                    ),
                    title: Text(product.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(product.brand, style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${_formatPrice(product.price)} UGX', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Color(0xFF94A3B8)),
                          onPressed: () => context.pushNamed('add-product', queryParameters: {'id': product.id}),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E)),
                          onPressed: () => _confirmDelete(context, market, product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('add-product'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MarketProvider market, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Delete Product?', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${product.name}"? This action cannot be undone.',
            style: const TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await market.deleteProduct(product.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product deleted successfully'), backgroundColor: AppColors.primary),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Color(0xFFF43F5E))),
          ),
        ],
      ),
    );
  }
}
