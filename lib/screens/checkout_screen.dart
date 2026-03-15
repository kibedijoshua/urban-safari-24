import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme/app_theme.dart';
import '../providers/auth_provider.dart';
import '../providers/cart_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();
    final cart = context.watch<CartProvider>();
    
    // Calculate details
    const shipping = 10000;
    final tax = (cart.totalPrice * 0.18).round();
    final total = cart.totalPrice + shipping + tax;
    
    final firstItemName = cart.items.isNotEmpty ? cart.items.first.product.name : 'your items';

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Top bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withOpacity(0.8),
              border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1))),
            ),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
              const Expanded(child: Text('Checkout', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(width: 48),
            ]),
          ),
          // Scrollable
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                // Order Summary
                const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF1E293B)),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(children: [
                    ...cart.items.map((item) => Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF1E293B)),
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            item.product.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withOpacity(0.2)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Qty: ${item.quantity} • ${item.selectedSize} • ${item.selectedColor}', 
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(cart.formatPrice(item.product.price), 
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                        ])),
                      ]),
                    )).toList(),
                    
                    const Divider(height: 1, color: Color(0xFF1E293B)),
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(children: [
                        _Row('Subtotal', cart.formatPrice(cart.totalPrice)),
                        const SizedBox(height: 6),
                        _Row('Delivery Fee', cart.formatPrice(shipping)),
                        const SizedBox(height: 6),
                        _Row('Tax (18% VAT)', cart.formatPrice(tax)),
                        const Divider(height: 20, color: Color(0xFF1E293B)),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          const Text('Total Amount', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Text(cart.formatPrice(total), 
                            style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900, fontSize: 17)),
                        ]),
                      ]),
                    ),
                  ]),
                ),
                const SizedBox(height: 20),

                // Security badge
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Icon(Icons.lock_outline, color: Color(0xFF64748B), size: 16),
                    const SizedBox(width: 6),
                    const Text('SECURE 256-BIT SSL ENCRYPTED CONNECTION',
                      style: TextStyle(fontSize: 10, color: Color(0xFF64748B), letterSpacing: 1, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ]),
            ),
          ),
          // Contact Seller buttons
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
            decoration: BoxDecoration(
              color: AppColors.backgroundDark.withOpacity(0.95),
              border: Border(top: BorderSide(color: const Color(0xFF1E293B))),
            ),
            child: Row(children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!auth.isLoggedIn) {
                      context.pushNamed('signup');
                      return;
                    }
                    final Uri telUri = Uri(scheme: 'tel', path: '+256709397670');
                    try {
                      await launchUrl(telUri);
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.phone_outlined, size: 18),
                  label: const Text('Call Seller', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () async {
                    if (!auth.isLoggedIn) {
                      context.pushNamed('signup');
                      return;
                    }
                    final String encodedMsg = Uri.encodeComponent('Hello, I want to buy $firstItemName and other items in my cart');
                    final Uri whatsappUri = Uri.parse('https://wa.me/256709397670?text=$encodedMsg');
                    try {
                      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
                    } catch (_) {}
                  },
                  icon: const Icon(Icons.chat_outlined, size: 18),
                  label: const Text('WhatsApp', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366), // WhatsApp Green
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(56),
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

class _Row extends StatelessWidget {
  final String l, v;
  const _Row(this.l, this.v);
  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
      Text(v, style: const TextStyle(fontSize: 13)),
    ],
  );
}
