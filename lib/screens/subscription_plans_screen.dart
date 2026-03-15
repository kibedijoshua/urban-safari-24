import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() => _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  int _selectedPlan = 1; // Pro selected by default

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
              const Expanded(child: Text('Choose Your Plan', textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              const SizedBox(width: 48),
            ]),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                // Hero text
                const SizedBox(height: 16),
                const Text('Elevate Your Store', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900), textAlign: TextAlign.center),
                const SizedBox(height: 10),
                const Text(
                  'Select a plan that fits your business scale and goals. Join our community of successful fashion sellers.',
                  style: TextStyle(color: Color(0xFF94A3B8), fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                // Starter plan
                _PlanCard(
                  isSelected: _selectedPlan == 0,
                  onTap: () => setState(() => _selectedPlan = 0),
                  name: 'Starter',
                  badge: 'Essential',
                  badgeIsPrimary: false,
                  price: 'UGX 0',
                  period: '/mo',
                  features: ['10% Sales Commission', 'Basic store listing', 'Standard support', 'Mobile app access'],
                  buttonLabel: 'Select Starter',
                  isPopular: false,
                ),
                const SizedBox(height: 16),
                // Pro plan
                _PlanCard(
                  isSelected: _selectedPlan == 1,
                  onTap: () => setState(() => _selectedPlan = 1),
                  name: 'Pro',
                  badge: 'Top Seller Choice',
                  badgeIsPrimary: true,
                  price: 'UGX 50,000',
                  period: '/mo',
                  features: ['5% Sales Commission', 'Advanced analytics dashboard', 'Featured homepage listings', 'Priority 24/7 support', 'Unlimited product uploads'],
                  buttonLabel: 'Select Pro',
                  isPopular: true,
                ),
                const SizedBox(height: 32),
                // CTA
                SizedBox(
                  width: double.infinity, height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Subscription activated! Welcome to Aura 🎉'),
                          backgroundColor: AppColors.primary, behavior: SnackBarBehavior.floating));
                      context.goNamed('seller');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Subscribe & Continue', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'By continuing, you agree to our Terms of Service and Merchant Agreement. Plans are billed monthly and can be canceled at any time.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF64748B), height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final bool isSelected, badgeIsPrimary, isPopular;
  final String name, badge, price, period, buttonLabel;
  final List<String> features;
  final VoidCallback onTap;

  const _PlanCard({
    required this.isSelected, required this.onTap, required this.name,
    required this.badge, required this.badgeIsPrimary, required this.price,
    required this.period, required this.features, required this.buttonLabel, required this.isPopular,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFF1E293B),
            width: isSelected ? 2 : 1,
          ),
          color: isSelected ? AppColors.primary.withOpacity(0.05) : AppColors.primary.withOpacity(0.02),
        ),
        child: Stack(children: [
          if (isPopular)
            Positioned(
              right: -24, top: -24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 6),
                decoration: const BoxDecoration(color: AppColors.primary),
                child: const Text('Popular', style: TextStyle(color: AppColors.backgroundDark, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              ),
            ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeIsPrimary ? AppColors.primary : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(badge, style: TextStyle(
                  color: badgeIsPrimary ? AppColors.backgroundDark : AppColors.primary,
                  fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ]),
            const SizedBox(height: 12),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(price, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900)),
              Text(period, style: const TextStyle(color: Color(0xFF64748B), fontSize: 15, fontWeight: FontWeight.w500)),
            ]),
            const SizedBox(height: 16),
            const Divider(color: Color(0xFF1E293B)),
            const SizedBox(height: 12),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(children: [
                const Icon(Icons.check_circle, color: AppColors.primary, size: 18),
                const SizedBox(width: 10),
                Text(f, style: const TextStyle(fontSize: 13, color: Color(0xFFCBD5E1))),
              ]),
            )),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity, height: 44,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected ? AppColors.primary : const Color(0xFF1E293B),
                  foregroundColor: isSelected ? AppColors.backgroundDark : Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(buttonLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ]),
        ]),
      ),
    );
  }
}
