import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/buyer_bottom_nav.dart';
import '../providers/market_provider.dart';

class MarketsScreen extends StatefulWidget {
  const MarketsScreen({super.key});

  @override
  State<MarketsScreen> createState() => _MarketsScreenState();
}

class _MarketsScreenState extends State<MarketsScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final marketProvider = context.watch<MarketProvider>();
    final allStores = marketProvider.stores;

    // Filter stores based on search query
    final stores = allStores.where((store) {
      final name = (store['name'] as String? ?? '').toLowerCase();
      final specialty = (store['specialty'] as String? ?? store['description'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase();
      return query.isEmpty || name.contains(query) || specialty.contains(query);
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Markets',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const Text(
                            'Explore curated stores in Kampala',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(
                          height: 48,
                          margin: const EdgeInsets.only(left: 16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Icon(Icons.search, color: AppColors.primary.withOpacity(0.5), size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: TextField(
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                  onChanged: (value) => setState(() => _searchQuery = value),
                                  decoration: InputDecoration(
                                    hintText: 'Search stores...',
                                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 14),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Store Listings
                Expanded(
                  child: marketProvider.isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 100),
                        itemCount: stores.length,
                        itemBuilder: (context, index) => _buildStoreCard(context, stores[index]),
                      ),
                ),
              ],
            ),
            // Bottom Nav
            const Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BuyerBottomNav(currentIndex: 2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoreCard(BuildContext context, Map<String, dynamic> store) {
    final String? imageUrl = store['image'] as String?;
    final String storeName = store['name'] as String? ?? 'Unnamed Store';
    final String specialty = store['specialty'] as String? ?? store['description'] as String? ?? 'Fashion & Style';
    final String category = store['category'] as String? ?? '';
    final num rating = store['rating'] as num? ?? 5.0;
    final int itemsCount = store['itemsCount'] as int? ?? 0;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed('store-details', pathParameters: {'id': store['id'] as String}),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.5),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          children: [
            // Image
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: imageUrl != null
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => _storePlaceholder(),
                      )
                    : _storePlaceholder(),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          specialty,
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          itemsCount.toString(),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text(
                          'Items',
                          style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _storePlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Center(
        child: Icon(Icons.store_outlined, color: AppColors.primary.withOpacity(0.4), size: 48),
      ),
    );
  }
}
