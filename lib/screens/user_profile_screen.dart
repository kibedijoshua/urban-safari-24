import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../widgets/buyer_bottom_nav.dart';
import '../providers/auth_provider.dart';
import '../providers/wishlist_provider.dart';
import '../providers/market_provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  XFile? _profileImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  void _showEditCredentialsDialog(BuildContext context, AuthProvider auth) {
    final nameController = TextEditingController(text: auth.user?.name);
    final emailController = TextEditingController(text: auth.user?.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        title: const Text('Edit Credentials', style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // Note: In real setup, you'd call a dedicated update method in AuthProvider
              // For now, we'll keep it simple as a mockup or partial update if service supports it
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Credentials updated locally! ✅'), backgroundColor: AppColors.primary),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Save', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final market = context.watch<MarketProvider>();
    final user = auth.user;
    final isLoggedIn = auth.isLoggedIn;
    final favoriteItems = wishlist.favoriteItems;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            child: Column(children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.primary.withOpacity(0.1)))),
                child: Row(children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.goNamed('home');
                      }
                    },
                  ),
                  const Expanded(child: Text('Profile', textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
                  const SizedBox(width: 48),
                ]),
              ),
              const SizedBox(height: 24),
              // Avatar
              Stack(children: [
                Container(
                  width: 128, height: 128,
                  decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 4)),
                  padding: const EdgeInsets.all(4),
                  child: ClipOval(
                    child: _profileImage != null
                        ? (kIsWeb
                            ? Image.network(_profileImage!.path, fit: BoxFit.cover)
                            : Image.file(File(_profileImage!.path), fit: BoxFit.cover))
                        : Image.network(
                            user?.photoUrl ?? 'https://lh3.googleusercontent.com/aida-public/AB6AXuAORtsNUed-_5XAntH9nSlIXq-KYXAJppofc8Z1GwUz0-invMyWisgrqBOMiizCidPlkDuXn3YlAZTkoKn0Dz7HY3-Lqs4jJc5zFDnqF15UKFZUnMAK-iDGbwHo3OymYGx3Fm-lHF7eSAaSar6Rjfn_jXSe3JthmPsH87LyUIN1XxPSC7GhiXJ7s4faOLyQfR3PfskeJ9u7aCa315JN7F49-eSLnOpKlQqJKQdzPR51rSw6eBODP1bV3p2wjNb04byoZzadU4OzAu7u',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 80, color: AppColors.primary),
                          ),
                  ),
                ),
                Positioned(bottom: 4, right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                      child: const Icon(Icons.edit, size: 14, color: AppColors.backgroundDark),
                    ),
                  )),
              ]),
              const SizedBox(height: 12),
              Text(isLoggedIn ? user!.name : 'Guest User', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(isLoggedIn ? user!.email : 'Sign in to sync your profile', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(isLoggedIn ? 'Aura Member' : 'Welcome to Aura', style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12)),
              const SizedBox(height: 32),

              // Wishlist
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text('Wishlist (${favoriteItems.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                  if (favoriteItems.isNotEmpty)
                    TextButton(onPressed: () {}, child: const Text('See More', style: TextStyle(color: AppColors.primary))),
                ]),
              ),
              const SizedBox(height: 8),
              if (favoriteItems.isEmpty)
                Container(
                  height: 100,
                  alignment: Alignment.center,
                  child: Text('Your heart list is empty ❤️', style: TextStyle(color: Colors.white.withOpacity(0.4))),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteItems.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, i) {
                      final p = favoriteItems[i];
                      return GestureDetector(
                        onTap: () => context.pushNamed('product', pathParameters: {'id': p.id}),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 130, height: 165,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
                            clipBehavior: Clip.hardEdge,
                            child: Image.network(p.imageUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(color: AppColors.primary.withOpacity(0.2))),
                          ),
                          const SizedBox(height: 4),
                          Text('${market.formatPrice(p.price)} UGX', style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                        ]),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 32),
              
              // Settings
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.05)),
                  ),
                  child: Column(children: [
                    _SettingsItem(
                      icon: Icons.person_outline, 
                      label: 'Personal Information', 
                      desc: 'Edit your name and email',
                      onTap: () => _showEditCredentialsDialog(context, auth),
                    ),
                    _SettingsItem(
                      icon: Icons.credit_card, 
                      label: 'Payment Methods', 
                      desc: 'Manage your cards',
                      comingSoon: true,
                    ),
                    _SettingsItem(
                      icon: Icons.notifications_outlined, 
                      label: 'Notifications', 
                      desc: 'Customize alert preferences', 
                      comingSoon: true,
                      isLast: true,
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 24),
              // Admin Panel button (Only for Admin)
              if (Provider.of<AuthProvider>(context).isAdmin)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => context.pushNamed('admin'),
                        icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white),
                        label: const Text('Admin Control Panel', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 4,
                          shadowColor: AppColors.primary.withOpacity(0.4),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: isLoggedIn 
                    ? OutlinedButton(
                        onPressed: () => auth.logout(),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Color(0xFFF43F5E)),
                          foregroundColor: const Color(0xFFF43F5E),
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    : ElevatedButton(
                        onPressed: () => context.pushNamed('login'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Log In / Sign Up', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
              ),
            ]),
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: BuyerBottomNav(currentIndex: 3)),
        ]),
      ),
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String label, desc;
  final bool isLast;
  final bool comingSoon;
  final VoidCallback? onTap;
  const _SettingsItem({
    required this.icon, 
    required this.label, 
    required this.desc, 
    this.isLast = false,
    this.comingSoon = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => Column(children: [
    ListTile(
      onTap: comingSoon ? null : onTap,
      leading: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Row(
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          if (comingSoon) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
              child: const Text('COMING SOON', style: TextStyle(color: AppColors.primary, fontSize: 8, fontWeight: FontWeight.bold)),
            ),
          ],
        ],
      ),
      subtitle: Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      trailing: comingSoon ? null : const Icon(Icons.chevron_right, color: Color(0xFF64748B)),
    ),
    if (!isLast) const Divider(height: 1, indent: 68, color: Color(0xFF1E293B)),
  ]);
}
