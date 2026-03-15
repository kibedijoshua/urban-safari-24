import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/market_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/buyer_bottom_nav.dart';
import '../widgets/product_card.dart';
import '../models/models.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  int _selectedCategory = 0;
  final List<String> _categories = ['All', 'clothing', 'shoes', 'caps', 'jerseys', 'boots', 'gadgets'];
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketProvider>();
    final allProductsData = market.allProducts;
    
    // Map to Product models
    final allProducts = allProductsData.map((p) => Product.fromMap(p, p['id'] as String)).toList();

    // Filter by category and search
    final filtered = allProducts.where((p) {
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesCategory = _selectedCategory == 0 || 
          p.category?.toLowerCase() == _categories[_selectedCategory].toLowerCase();
          
      return matchesSearch && matchesCategory;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: AppColors.backgroundDark,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.goNamed('home');
                    }
                  },
                ),
                title: Row(children: const [
                  Icon(Icons.local_mall, color: AppColors.primary, size: 28),
                  SizedBox(width: 8),
                  Text('Fashion Hub', style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                actions: [
                  IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () {}),
                  IconButton(icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white), onPressed: () => context.goNamed('cart')),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(104),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(children: [
                        Expanded(
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(children: [
                              const SizedBox(width: 12),
                              const Icon(Icons.search, color: Color(0xFF64748B)),
                              const SizedBox(width: 8),
                              Expanded(child: TextField(
                                style: const TextStyle(color: Colors.white),
                                onChanged: (value) => setState(() => _searchQuery = value),
                                decoration: const InputDecoration(
                                  hintText: 'Search products...',
                                  hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              )),
                            ]),
                          ),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 48,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) => GestureDetector(
                          onTap: () => setState(() => _selectedCategory = i),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: _selectedCategory == i ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            alignment: Alignment.center,
                            child: Text(_categories[i],
                              style: TextStyle(
                                color: _selectedCategory == i ? AppColors.backgroundDark : Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 14,
                              )),
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                sliver: SliverToBoxAdapter(
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text('Showing ${filtered.length} items', style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                    const Row(children: [
                      Text('Sort by: Newest', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 13)),
                      Icon(Icons.expand_more, color: AppColors.primary, size: 18),
                    ]),
                  ]),
                ),
              ),
              if (market.isLoading && filtered.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (filtered.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.shopping_bag_outlined, color: AppColors.primary.withOpacity(0.3), size: 80),
                      const SizedBox(height: 16),
                      const Text('No products found', style: TextStyle(color: Colors.white60, fontSize: 16)),
                      const SizedBox(height: 8),
                      const Text('Try changing your search or category', style: TextStyle(color: Colors.white38, fontSize: 13)),
                    ]),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, childAspectRatio: 0.62, crossAxisSpacing: 12, mainAxisSpacing: 12),
                    delegate: SliverChildBuilderDelegate(
                      (_, i) => ProductCard(
                        product: filtered[i],
                        onTap: () => context.pushNamed('product', pathParameters: {'id': filtered[i].id}),
                      ),
                      childCount: filtered.length,
                    ),
                  ),
                ),
            ],
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: BuyerBottomNav(currentIndex: 1)),
        ]),
      ),
    );
  }
}
