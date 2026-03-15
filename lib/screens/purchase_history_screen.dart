import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/buyer_bottom_nav.dart';

class PurchaseHistoryScreen extends StatelessWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final history = cart.purchaseHistory;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          if (context.canPop()) {
                            context.pop();
                          } else {
                            context.goNamed('home');
                          }
                        },
                      ),
                      const SizedBox(width: 8),
                      const Text('Purchase History', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
                if (!auth.isAuthenticated)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_toggle_off, size: 64, color: Color(0xFF64748B)),
                          const SizedBox(height: 16),
                          const Text('Please login to view history', style: TextStyle(color: Color(0xFF94A3B8))),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () => context.pushNamed('login'),
                            child: const Text('Login Now'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (history.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('No purchases yet', style: TextStyle(color: Color(0xFF94A3B8))),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final purchase = history[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primary.withOpacity(0.1)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(purchase.id, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                  Text(
                                    '${purchase.date.day}/${purchase.date.month}/${purchase.date.year}',
                                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              ...purchase.items.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(item.product.imageUrl, width: 40, height: 40, fit: BoxFit.cover),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                          Text('Quantity: ${item.quantity}', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                                        ],
                                      ),
                                    ),
                                    Text(cart.formatPrice(item.product.price * item.quantity)),
                                  ],
                                ),
                              )),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(cart.formatPrice(purchase.totalAmount), style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
            const Positioned(bottom: 0, left: 0, right: 0, child: BuyerBottomNav(currentIndex: 1)),
          ],
        ),
      ),
    );
  }
}
