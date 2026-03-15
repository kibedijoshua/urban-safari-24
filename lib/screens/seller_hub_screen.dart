import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../widgets/seller_bottom_nav.dart';

class SellerHubScreen extends StatelessWidget {
  const SellerHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = [
      {'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuAQY9ZmbJFrxT-ls3K7aW8HZtWsJB4ldA-gW_gWyUI2lQjPol9rdtjGKQ8d1jajoydgOz3NM4bxU7Ye5VV1NRRwe6_ig4DNHcF4WXWDi5VTrx70Rz5zhDBc4L8N5WFOMwZc2IFFrolcVXCWrQqShdppGNjkUgrY2NLJlLmR1HOLsoKZFYM-NQxzigiW76dNzzH3FWQ-gwO2eFgdaK0DY4BR_Qse3aiqEyXKDdGeBX95sYWrZp2dGq-HfQRTAm5gkhilzBPi5U9t55AV', 'order': 'Order #8492', 'customer': 'Namukasa J. • 2 mins ago', 'amount': 'UGX 45,000', 'status': 'Paid', 'isPaid': true},
      {'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuDmnDbiBRn7VDln4rrk9X6r-zb8fFEH2Lpolo75zDsJIq_bz5rk7XY7JpZ2HK8MbMvaJC12XiJjtABhJLgcxUH_cfR8Ynw2rfbm-j-wLYhjJpf933RTQt-nVMY6ZPen2SCXb2-jVCNzQjEPgnZKZc6OT2Yf33-drHJz6biIY6_gcDeBN6VSTO4rKSXHNVtaCbzpMRX8Cvrs6QZu_OUcLxVnHo5i4tyqW0qI0svweMLpoxvZLtzo34ahNiw15j7eOrxuPWP7qfb7SSMX', 'order': 'Order #8491', 'customer': 'Okello B. • 1 hour ago', 'amount': 'UGX 120,000', 'status': 'Pending', 'isPaid': false},
      {'img': 'https://lh3.googleusercontent.com/aida-public/AB6AXuBJ4Qu_QoQ2pvVe4hLHpXVW8pICPHkbaZvqAkmevH1buUIrlZHMQ-S8mYSVY83H-J0doSifIffeWZkUNYpmmRVV4fHteaPAIkxFmWdRj1VTu_cI6PCFPWdvS39EzsW5lMoY9ZZGLmXmDujEW0cErcMrJ_uJFDlsAi-hhO12PMYPROcaAtLVgIctli45HF31PFLdTnE8f7Wb8tjm5QPZFcTKSjaMRfTt5pI9jDz1Uq_1coL-0dOBsm3dIxMtd4Zr_IJ8xLqajrU1oSx4', 'order': 'Order #8490', 'customer': 'Sempala R. • 3 hours ago', 'amount': 'UGX 210,000', 'status': 'Paid', 'isPaid': true},
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
                    const Icon(Icons.storefront, color: AppColors.primary, size: 36),
                    const SizedBox(height: 16),
                    const Text('SELLER HUB', style: TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: 2)),
                    const SizedBox(height: 4),
                    const Text('Manage Your Store', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dashboard_outlined, color: Colors.white),
                      title: const Text('Dashboard', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.goNamed('seller'); },
                    ),
                    ListTile(
                      leading: const Icon(Icons.inventory_2_outlined, color: Colors.white),
                      title: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.pushNamed('add-product'); },
                    ),
                    ListTile(
                      leading: const Icon(Icons.settings_outlined, color: Colors.white),
                      title: const Text('Store Setup', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      onTap: () { Navigator.pop(context); context.pushNamed('store-setup'); },
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
                child: ListTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tileColor: AppColors.primary.withOpacity(0.05),
                  iconColor: Colors.white,
                  textColor: Colors.white,
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Return to Buyer Mode', style: TextStyle(fontWeight: FontWeight.bold)),
                  onTap: () { Navigator.pop(context); context.goNamed('home'); },
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            // Header
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Builder(
                    builder: (c) => GestureDetector(
                      onTap: () => Scaffold.of(c).openDrawer(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(10)),
                        child: const Icon(Icons.menu, color: AppColors.backgroundDark, size: 22),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Text('Seller Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ]),
                Row(children: [
                  Stack(children: [
                    IconButton(icon: const Icon(Icons.notifications_outlined), onPressed: () {}),
                    Positioned(right: 8, top: 8, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle))),
                  ]),
                  Container(
                    width: 40, height: 40,
                    decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary, width: 2)),
                    clipBehavior: Clip.hardEdge,
                    child: Image.network(
                      'https://lh3.googleusercontent.com/aida-public/AB6AXuAtce-x6zMscL9ExN_SlEExCYZDHHzpO_ooxEJIS5o0a5EqByB593nf8vZ1VDEXa86JWaZyayJSsjc_Gjxx-QTDSozKL-nvjyEe1tYIEXTKDoEfXIcDGMTQk-OI77gyJmwfa4WMPV58vBnhkUf758syTRI8vSus3I4qOqPfeYO40-BT0W2CTUJbkY3Oxl8k_nwKgHlMKTyKC-66HSMJwxHyyKdVH7I0zJ_cJ9lZnFDKf0BiQSLiPSsxBhR75LD2cLPTXytFMJAYcPTt',
                      fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.person, color: AppColors.primary)),
                  ),
                ]),
              ]),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Morning, Artisan!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  const Text("Here's what's happening with your store today.", style: TextStyle(color: Color(0xFF64748B))),
                  const SizedBox(height: 20),
                  // Stats
                  Row(children: [
                    Expanded(child: _StatCard('Total Sales', 'UGX 1,250,000', Icons.payments, '+12.5%', AppColors.emerald500)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard('Net Earnings', 'UGX 1,125,000', Icons.account_balance_wallet, null, null)),
                  ]),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(child: _StatCard('Active Listings', '48', Icons.inventory_2_outlined, 'Stable', Colors.grey)),
                    const SizedBox(width: 10),
                    Expanded(child: _StatCard('Pending Orders', '12', Icons.pending_actions_outlined, '-5%', AppColors.rose500)),
                  ]),
                  const SizedBox(height: 24),
                  // Recent orders
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.primary.withOpacity(0.05)),
                    ),
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                          TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold))),
                        ]),
                      ),
                      const Divider(height: 1, color: Color(0xFF1E293B)),
                      ...orders.map((o) => Column(children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(children: [
                            Container(
                              width: 52, height: 52,
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.primary.withOpacity(0.1)),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(o['img'] as String, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Icon(Icons.image, color: AppColors.primary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(o['order'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              Text(o['customer'] as String, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                            ])),
                            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                              Text(o['amount'] as String, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: (o['isPaid'] as bool) ? AppColors.emerald500.withOpacity(0.1) : AppColors.amber500.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(o['status'] as String,
                                  style: TextStyle(color: (o['isPaid'] as bool) ? AppColors.emerald500 : AppColors.amber500, fontSize: 10, fontWeight: FontWeight.bold)),
                              ),
                            ]),
                          ]),
                        ),
                        if (o != orders.last) const Divider(height: 1, indent: 76, color: Color(0xFF1E293B)),
                      ])),
                    ]),
                  ),
                ]),
              ),
            ),
          ]),
          // FAB
          Positioned(
            bottom: 90, right: 16,
            child: FloatingActionButton(
              onPressed: () => context.pushNamed('add-product'),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark,
              child: const Icon(Icons.add, size: 28),
            ),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: SellerBottomNav(currentIndex: 0)),
        ]),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label, value;
  final IconData icon;
  final String? badge;
  final Color? badgeColor;
  const _StatCard(this.label, this.value, this.icon, this.badge, this.badgeColor);

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.04),
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.primary.withOpacity(0.05)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        if (badge != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(color: badgeColor!.withOpacity(0.1), borderRadius: BorderRadius.circular(99)),
            child: Text(badge!, style: TextStyle(color: badgeColor!, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
      ]),
      const SizedBox(height: 10),
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
      const SizedBox(height: 4),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
    ]),
  );
}
