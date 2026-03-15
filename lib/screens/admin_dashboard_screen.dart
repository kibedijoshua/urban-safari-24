import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../providers/market_provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final market = context.watch<MarketProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text('Admin Control Panel', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome Back, Admin',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your marketplace and stores here.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Stats Row
            Row(
              children: [
                _buildStatCard('${market.stores.length}', 'Active Stores', Icons.storefront_outlined, const Color(0xFF3B82F6)),
                const SizedBox(width: 16),
                _buildStatCard('Live', 'Marketplace', Icons.inventory_2_outlined, AppColors.primary),
              ],
            ),
            const SizedBox(height: 32),

            // Actions Section
            const Text(
              'QUICK ACTIONS',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 2),
            ),
            const SizedBox(height: 16),
            
            _buildActionItem(
              context: context,
              icon: Icons.add_circle_outline,
              title: 'Post New Item',
              subtitle: 'Upload product details to a store catalog',
              color: AppColors.primary,
              onTap: () => context.pushNamed('add-product'),
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context: context,
              icon: Icons.store_outlined,
              title: 'Manage Stores',
              subtitle: 'Edit store details and branding',
              color: const Color(0xFF3B82F6),
              onTap: () => context.pushNamed('manage-stores'),
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context: context,
              icon: Icons.inventory_2_outlined,
              title: 'Manage Products',
              subtitle: 'Edit or delete existing listings',
              color: AppColors.primary,
              onTap: () => context.pushNamed('manage-products'),
            ),
            const SizedBox(height: 16),
            _buildActionItem(
              context: context,
              icon: Icons.analytics_outlined,
              title: 'View Analytics',
              subtitle: 'Track your store sales and clicks',
              color: const Color(0xFF10B981),
              onTap: () {},
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 16),
            Text(value, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF334155).withOpacity(0.5)),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
      ),
    );
  }
}
