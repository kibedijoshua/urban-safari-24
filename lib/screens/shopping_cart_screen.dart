import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/cart_provider.dart';

class ShoppingCartScreen extends StatelessWidget {
  const ShoppingCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final shipping = 10000;
    final tax = (cart.totalPrice * 0.18).round();
    final total = cart.totalPrice + shipping + tax;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
            child: Row(children: [
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
              const Expanded(child: Text('Shopping Cart', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
              const SizedBox(width: 48),
            ]),
          ),
          // Contents
          Expanded(
            child: cart.items.isEmpty
              ? const Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.shopping_cart_outlined, size: 64, color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Color(0xFF64748B))),
                ]))
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: cart.items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (_, i) {
                    final item = cart.items[i];
                    return Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      Container(
                        width: 90, height: 90,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(item.product.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withOpacity(0.2))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(item.product.name,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                        const SizedBox(height: 2),
                        Text('Size: ${item.selectedSize} | ${item.selectedColor}',
                          style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(cart.formatPrice(item.product.price),
                          style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      ])),
                      Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 22, color: Color(0xFF64748B)),
                          onPressed: () => cart.removeFromCart(item.product.id),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Row(children: [
                            GestureDetector(
                              onTap: () => cart.decrement(item.product.id),
                              child: Container(width: 28, height: 28,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.remove, size: 16, color: AppColors.backgroundDark)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            ),
                            GestureDetector(
                              onTap: () => cart.increment(item.product.id),
                              child: Container(width: 28, height: 28,
                                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                                child: const Icon(Icons.add, size: 16, color: AppColors.backgroundDark)),
                            ),
                          ]),
                        ),
                      ]),
                    ]);
                  },
                ),
          ),
          // Summary
          if (cart.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.05),
                border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.1))),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(children: [
                _SummaryRow('Subtotal', cart.formatPrice(cart.totalPrice)),
                const SizedBox(height: 8),
                _SummaryRow('Shipping', cart.formatPrice(shipping)),
                const SizedBox(height: 8),
                _SummaryRow('Tax (VAT 18%)', cart.formatPrice(tax)),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFF334155)),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  Text(cart.formatPrice(total),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 22)),
                ]),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: () => context.pushNamed('checkout'),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Proceed to Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
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

class _SummaryRow extends StatelessWidget {
  final String label, value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
    ],
  );
}
