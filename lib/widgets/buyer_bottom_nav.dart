import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class BuyerBottomNav extends StatelessWidget {
  final int currentIndex;
  const BuyerBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final items = [
      {'icon': Icons.home_outlined, 'filledIcon': Icons.home, 'label': 'Home', 'route': 'home'},
      {'icon': Icons.grid_view_outlined, 'filledIcon': Icons.grid_view, 'label': 'Shop', 'route': 'shop'},
      {'icon': Icons.storefront_outlined, 'filledIcon': Icons.storefront, 'label': 'Markets', 'route': 'markets'},
      {'icon': Icons.person_outline, 'filledIcon': Icons.person, 'label': 'Profile', 'route': 'profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundDark,
        border: Border(top: BorderSide(color: AppColors.primary.withOpacity(0.2))),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final active = currentIndex == i;
              return GestureDetector(
                onTap: () => context.goNamed(items[i]['route'] as String),
                behavior: HitTestBehavior.translucent,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Icon(
                      active ? items[i]['filledIcon'] as IconData : items[i]['icon'] as IconData,
                      color: active ? AppColors.primary : const Color(0xFF64748B),
                      size: 24,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      items[i]['label'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: active ? AppColors.primary : const Color(0xFF64748B),
                        letterSpacing: 0.5,
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
