import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Stack(
        children: [
          // Hero image
          Positioned.fill(
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCHU074PvM0USCVl6qZy7a94mUnHIoAHpdg1hARgm1CyNYMEfm3RK8GvDAyqB5f02xj0zn7af11sOyCTv08knhzid2EZKZR2VlPnO05IUKSXS1jm36GLHcbWMHgeuCaqswcGCOItI3Ch9B6aGtp1EeeulzNlN7N0AXeaiBR0NSoBEdpCJtONM6NwZ_FWGCxF__EZ44E4JRvBWDr9N-tVPBcpWE4gcFZCkSNNYUK56GAdh-aI74qgGQaMz5vx7ZUQX30MPVlUUPesIvw',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(color: AppColors.backgroundDark),
            ),
          ),
          // Gradient overlay
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.backgroundDark.withOpacity(0.0),
                    AppColors.backgroundDark.withOpacity(0.9),
                  ],
                ),
              ),
            ),
          ),
          // Top bar
          Positioned(
            top: 0, left: 0, right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 28), // Placeholder to maintain centered title if needed, or just remove. Let's just remove the icon.
                    Row(
                      children: [
                        Container(
                          width: 32, height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.star, color: AppColors.backgroundDark, size: 18),
                        ),
                        const SizedBox(width: 8),
                        const Text('Aura',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.primary,
                      ),
                      onPressed: () => context.goNamed('home'),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Skip', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward_ios, size: 14),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Bottom content
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: FadeTransition(
              opacity: _fadeIn,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 48, height: 1,
                          child: DecoratedBox(decoration: BoxDecoration(color: AppColors.primary)),
                        ),
                        const SizedBox(width: 12),
                        const Text("Uganda's Finest Craftsmanship",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text('Premium\n',
                      style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, height: 1.1),
                      textAlign: TextAlign.center,
                    ),
                    const Text.rich(
                      TextSpan(children: [
                        TextSpan(text: 'African ', style: TextStyle(color: AppColors.primary, fontSize: 48, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                        TextSpan(text: 'Fashion', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900)),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Discover a curated collection of contemporary luxury design.',
                      style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 17, fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: () => context.goNamed('home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.backgroundDark,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Explore Collection',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Page indicators
          Positioned(
            bottom: 24,
            left: 0, right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 32, height: 4, decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 6),
                Container(width: 8, height: 4, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
                const SizedBox(width: 6),
                Container(width: 8, height: 4, decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.3), borderRadius: BorderRadius.circular(4))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(value, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 20)),
      Text(label, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 10, letterSpacing: 1)),
    ]);
  }
}
