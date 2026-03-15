import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/market_provider.dart';

class StoreDetailsScreen extends StatefulWidget {
  final String storeId;
  const StoreDetailsScreen({super.key, required this.storeId});

  @override
  State<StoreDetailsScreen> createState() => _StoreDetailsScreenState();
}

class _StoreDetailsScreenState extends State<StoreDetailsScreen> {
  Map<String, dynamic>? _storeInfo;
  bool _isLoadingStore = true;

  @override
  void initState() {
    super.initState();
    _loadStoreInfo();
  }

  Future<void> _loadStoreInfo() async {
    final market = context.read<MarketProvider>();
    final info = await market.getStoreInfo(widget.storeId);
    if (mounted) {
      setState(() {
        _storeInfo = info;
        _isLoadingStore = false;
      });
      // Trigger a proactive recount to ensure the counter is accurate
      market.syncStoreStats(widget.storeId);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingStore) {
      return const Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_storeInfo == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Store not found', style: TextStyle(color: Colors.white)),
              TextButton(onPressed: () => context.pop(), child: const Text('Go Back')),
            ],
          ),
        ),
      );
    }

    final market = context.watch<MarketProvider>();
    final productsStream = market.getStoreProducts(widget.storeId);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // Banner App Bar
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.backgroundDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                   Image.network(
                    _storeInfo!['image'] ?? _storeInfo!['banner'] ?? '', 
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.black45),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.4),
                          AppColors.backgroundDark,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Store Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60, height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            (_storeInfo!['name'] as String).substring(0, 2).toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _storeInfo!['name']!,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.verified, color: AppColors.primary, size: 16),
                                SizedBox(width: 4),
                                Text('Verified Premium Seller', style: TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _storeInfo!['specialty'] ?? _storeInfo!['description'] ?? 'No description available',
                    style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Color(0xFF334155)),
                  const SizedBox(height: 8),
                  const Text(
                    'STORE CATALOG',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Product Grid
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: productsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
              }
              
              final products = snapshot.data ?? [];
              
              if (products.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(48.0),
                    child: Center(child: Text('No products found', style: TextStyle(color: Color(0xFF94A3B8)))),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildCatalogItem(context, products[index]),
                    childCount: products.length,
                  ),
                ),
              );
            }
          ),
          
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildCatalogItem(BuildContext context, Map<String, dynamic> product) {
    final auth = context.read<AuthProvider>();
    final storePhone = _storeInfo?['phoneNumber'] as String? ?? '+256709397670';

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.pushNamed('product', pathParameters: {'id': product['id']}),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B).withOpacity(0.3),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Image.network(
                product['imageUrl'] ?? product['image'] ?? '',
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.black12, 
                  child: const Center(child: Icon(Icons.shopping_bag_outlined, color: Colors.white24, size: 32))
                ),
              ),
            ),
            // Details
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'] ?? 'Untitled Item',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'UGX ${product['price']}',
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildIconButton(
                          icon: Icons.phone_outlined,
                          color: const Color(0xFF3B82F6),
                          onTap: () async {
                            if (!auth.isLoggedIn) {
                              context.pushNamed('login');
                            } else {
                              final Uri telUri = Uri(scheme: 'tel', path: storePhone.replaceAll(' ', ''));
                              try { await launchUrl(telUri); } catch (_) {}
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildIconButton(
                          icon: Icons.chat_outlined,
                          color: const Color(0xFF10B981),
                          onTap: () async {
                            if (!auth.isLoggedIn) {
                              context.pushNamed('login');
                            } else {
                              final String cleanPhone = storePhone.replaceAll('+', '').replaceAll(' ', '');
                              final productName = product['name'] ?? 'this item';
                              final String encodedMsg = Uri.encodeComponent('Hello, I want to buy $productName');
                              final Uri waUri = Uri.parse('https://wa.me/$cleanPhone?text=$encodedMsg');
                              try { await launchUrl(waUri, mode: LaunchMode.externalApplication); } catch (_) {}
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}
