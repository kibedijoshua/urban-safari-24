import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SellerBottomNav extends StatelessWidget {
  final int currentIndex;
  const SellerBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.dashboard_outlined, 'filledIcon': Icons.dashboard, 'label': 'Home', 'route': 'seller'},
      {'icon': Icons.shopping_bag_outlined, 'filledIcon': Icons.shopping_bag, 'label': 'Orders', 'route': 'seller'},
      {'icon': Icons.inventory_outlined, 'filledIcon': Icons.inventory, 'label': 'Products', 'route': 'add-product'},
      {'icon': Icons.insights_outlined, 'filledIcon': Icons.insights, 'label': 'Stats', 'route': 'seller'},
      {'icon': Icons.settings_outlined, 'filledIcon': Icons.settings, 'label': 'Settings', 'route': 'store-setup'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF27241B),
        border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.1))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = currentIndex == i;
              return GestureDetector(
                onTap: () => context.goNamed(items[i]['route'] as String),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      active ? items[i]['filledIcon'] as IconData : items[i]['icon'] as IconData,
                      color: active ? AppColors.primary : const Color(0xFFBAB29C),
                      size: 22,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5,
                        color: active ? AppColors.primary : const Color(0xFFBAB29C),
                      ),
                    ),
                  ]),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
