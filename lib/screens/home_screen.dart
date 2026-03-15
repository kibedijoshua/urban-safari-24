import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../widgets/buyer_bottom_nav.dart';
import '../widgets/product_card.dart';
import '../providers/market_provider.dart';
import '../models/models.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final market = context.watch<MarketProvider>();
    final products = market.allProducts.map((p) => Product.fromMap(p, p['id'] as String)).toList();

    final categories = [
      {'label': 'clothing', 'img': 'assets/categories/clothing.png'},
      {'label': 'shoes', 'img': 'assets/categories/shoes.png'},
      {'label': 'caps', 'img': 'assets/categories/caps.png'},
      {'label': 'jerseys', 'img': 'assets/categories/jerseys.png'},
      {'label': 'boots', 'img': 'assets/categories/boots.png'},
      {'label': 'gadgets', 'img': 'assets/categories/gadgets.png'},
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      drawer: Drawer(
        backgroundColor: AppColors.backgroundDark,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1))),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.star, color: AppColors.primary, size: 36),
                    const SizedBox(height: 16),
                    const Text('AURA UGANDA', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 4),
                    const Text('Premium African Fashion', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.home_outlined, color: Colors.white),
                      title: const Text('Home', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.goNamed('home'); },
                    ),
                    ListTile(
                      leading: const Icon(Icons.grid_view_outlined, color: Colors.white),
                      title: const Text('Shop All Products', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.goNamed('shop'); },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite_outline, color: Colors.white),
                      title: const Text('Saved Items', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); /* TODO */ },
                    ),
                    ListTile(
                      leading: const Icon(Icons.person_outline, color: Colors.white),
                      title: const Text('My Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.goNamed('profile'); },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverAppBar(
                  pinned: true,
                  backgroundColor: AppColors.backgroundDark,
                  elevation: 0,
                  title: const Text('Fashion UG', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  centerTitle: true,
                  leading: Builder(
                    builder: (c) => IconButton(
                      icon: const Icon(Icons.menu, color: AppColors.primary),
                      onPressed: () => Scaffold.of(c).openDrawer(),
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: IconButton(
                        icon: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(Icons.shopping_bag_outlined, color: Colors.white),
                            if (cart.itemCount > 0)
                              Positioned(
                                right: -4, top: -4,
                                child: Container(
                                  width: 16, height: 16,
                                  decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                  child: Center(
                                    child: Text('${cart.itemCount}',
                                      style: const TextStyle(color: AppColors.backgroundDark, fontSize: 10, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        onPressed: () => context.goNamed('cart'),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: GestureDetector(
                        onTap: () => context.pushNamed('shop'),
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(children: [
                            const SizedBox(width: 12),
                            Icon(Icons.search, color: AppColors.primary.withOpacity(0.6)),
                            const SizedBox(width: 8),
                            Text("Search Kampala's best styles...",
                              style: TextStyle(color: AppColors.primary.withOpacity(0.4), fontSize: 14)),
                          ]),
                        ),
                      ),
                    ),
                  ),
                ),
                // Categories
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 120,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 20),
                      itemBuilder: (_, i) => Column(
                        children: [
                          GestureDetector(
                            onTap: () => context.pushNamed('shop'),
                            child: Container(
                              width: 65, height: 65,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary.withOpacity(0.2),
                                border: Border.all(color: AppColors.primary.withOpacity(0.3), width: 2),
                              ),
                              child: ClipOval(
                                child: Image.asset(categories[i]['img']!, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(color: AppColors.backgroundDark)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(categories[i]['label']!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFCBD5E1))),
                        ],
                      ),
                    ),
                  ),
                ),
                // Hero banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Trending Outfits',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () => context.pushNamed('shop'),
                        child: Container(
                          height: 240,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                          clipBehavior: Clip.hardEdge,
                          child: Stack(children: [
                            Positioned.fill(
                              child: Image.network(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCQQEViQ3WQtDF8VI2Xc1LAp31mafwcp3aXe43-XVLDyMeJuu5olxOSzPzKiXZSH9WIoldKqDIIveSQAk2eN1Nv5q3kGTPiPHBBsmNo1qBFB15FwhX8ZzsK1H4qg5yqSqDn4hbFoTpJMu58JA7rP1n1UZ2INy6Tweub7u_8mssl0qFZqM4vKgPLZzkIX9yQMbaR8Gj6ErJedMcA0TWMtpGWn7z-CMcuIhbjexS5q69KyjAOw72gMk7y6Qo2EcuMX5uOLoHsf62AZfVR',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withOpacity(0.2)),
                              ),
                            ),
                            Positioned.fill(
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(bottom: 16, left: 16, right: 16, child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(99)),
                                  child: const Text('New Collection', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.backgroundDark, letterSpacing: 1)),
                                ),
                                const SizedBox(height: 4),
                                const Text("Urban Safari '24",
                                  style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                const Text('Discover the essence of contemporary Kampala style.',
                                  style: TextStyle(color: Colors.white70, fontSize: 13)),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () => context.pushNamed('shop'),
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text('Shop Now', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            )),
                          ]),
                        ),
                      ),
                    ]),
                  ),
                ),
                // Promo banner
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          child: const Icon(Icons.local_offer, color: AppColors.backgroundDark, size: 20),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('End of Month Sale', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('Get up to 40% off on all selected items',
                            style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                        ])),
                        TextButton(
                          onPressed: () => context.pushNamed('shop'),
                          child: const Text('View', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ),
                      ]),
                    ),
                  ),
                ),
                // New Arrivals
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text('New Arrivals', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('See all', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600, fontSize: 14)),
                    ]),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  sliver: market.isLoading && products.isEmpty
                    ? const SliverToBoxAdapter(child: Center(child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      )))
                    : products.isEmpty
                      ? SliverToBoxAdapter(child: Center(child: Column(children: [
                          const SizedBox(height: 32),
                          Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 64),
                          const SizedBox(height: 16),
                          const Text('No products available yet', style: TextStyle(color: Colors.white38)),
                        ])))
                      : SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 0.65, crossAxisSpacing: 12, mainAxisSpacing: 12),
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => ProductCard(
                              product: products[i],
                              onTap: () => context.pushNamed('product', pathParameters: {'id': products[i].id}),
                            ),
                            childCount: products.length > 8 ? 8 : products.length,
                          ),
                        ),
                ),
              ],
            ),
            const Positioned(
              bottom: 0, left: 0, right: 0,
              child: BuyerBottomNav(currentIndex: 0),
            ),
          ],
        ),
      ),
    );
  }
}
