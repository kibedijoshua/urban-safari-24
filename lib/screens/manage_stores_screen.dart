import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/market_provider.dart';

class ManageStoresScreen extends StatelessWidget {
  const ManageStoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketProvider>();
    final stores = market.allStores;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Manage Stores', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: stores.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.storefront_outlined, color: AppColors.primary.withOpacity(0.3), size: 80),
                  const SizedBox(height: 16),
                  const Text('No stores found', style: TextStyle(color: Colors.white60, fontSize: 16)),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.pushNamed('store-setup'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Your First Store'),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.black),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: stores.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final store = stores[index];
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
                        image: store['image'] != null
                            ? DecorationImage(image: NetworkImage(store['image'] as String), fit: BoxFit.cover)
                            : null,
                      ),
                      child: store['image'] == null ? const Icon(Icons.storefront, color: AppColors.primary) : null,
                    ),
                    title: Text(store['name'] ?? 'Unnamed Store', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(store['category'] ?? 'General', style: TextStyle(color: AppColors.primary.withOpacity(0.8), fontSize: 12)),
                        const SizedBox(height: 4),
                        Text('${store['itemsCount'] ?? 0} Products', style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: Color(0xFF94A3B8)),
                          onPressed: () => context.pushNamed('store-setup', queryParameters: {'id': store['id']}),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Color(0xFFF43F5E)),
                          onPressed: () => _confirmDelete(context, market, store),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushNamed('store-setup'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _confirmDelete(BuildContext context, MarketProvider market, Map<String, dynamic> store) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Delete Store?', style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete "${store['name']}"? This will also delete all products in this store.',
            style: const TextStyle(color: Color(0xFF94A3B8))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await market.deleteStore(store['id'] as String);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Store deleted successfully'), backgroundColor: AppColors.primary),
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
