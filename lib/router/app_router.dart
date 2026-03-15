import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../screens/splash_screen.dart';
import '../screens/home_screen.dart';
import '../screens/product_listing_screen.dart';
import '../screens/product_details_screen.dart';
import '../screens/shopping_cart_screen.dart';
import '../screens/checkout_screen.dart';
import '../screens/user_profile_screen.dart';
import '../screens/seller_hub_screen.dart';
import '../screens/add_product_screen.dart';
import '../screens/store_setup_screen.dart';
import '../screens/subscription_plans_screen.dart';
import '../screens/login_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/markets_screen.dart';
import '../screens/store_details_screen.dart';
import '../screens/admin_dashboard_screen.dart';
import '../screens/manage_stores_screen.dart';
import '../screens/manage_products_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final auth = context.read<AuthProvider>();
    final path = state.uri.path;
    
    // List of routes that only the admin (menhyajoshua@gmail.com) can access
    final adminRoutes = [
      '/admin',
      '/seller',
      '/seller/add-product',
      '/seller/store-setup',
      '/seller/subscription',
    ];

    if (adminRoutes.any((route) => path.startsWith(route))) {
      if (!auth.isAdmin) {
        return '/home';
      }
    }
    if (path == '/') {
      if (auth.isLoggedIn) {
        return '/home';
      }
    }
    
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      pageBuilder: (context, state) => const NoTransitionPage(child: SplashScreen()),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: 'signup',
      builder: (context, state) => const SignupScreen(),
    ),
    GoRoute(
      path: '/shop',
      name: 'shop',
      builder: (context, state) => const ProductListingScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      name: 'product',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return ProductDetailsScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/cart',
      name: 'cart',
      builder: (context, state) => const ShoppingCartScreen(),
    ),
    GoRoute(
      path: '/checkout',
      name: 'checkout',
      builder: (context, state) => const CheckoutScreen(),
    ),
    GoRoute(
      path: '/markets',
      name: 'markets',
      builder: (context, state) => const MarketsScreen(),
    ),
    GoRoute(
      path: '/store/:id',
      name: 'store-details',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return StoreDetailsScreen(storeId: id);
      },
    ),
    GoRoute(
      path: '/admin/stores',
      name: 'manage-stores',
      builder: (context, state) => const ManageStoresScreen(),
    ),
    GoRoute(
      path: '/admin/products',
      name: 'manage-products',
      builder: (context, state) => const ManageProductsScreen(),
    ),
    GoRoute(
      path: '/admin',
      name: 'admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const UserProfileScreen(),
    ),
    GoRoute(
      path: '/seller',
      name: 'seller',
      builder: (context, state) => const SellerHubScreen(),
    ),
    GoRoute(
      path: '/seller/add-product',
      name: 'add-product',
      builder: (context, state) {
        final id = state.uri.queryParameters['id'];
        return AddProductScreen(productId: id);
      },
    ),
    GoRoute(
      path: '/seller/store-setup',
      name: 'store-setup',
      builder: (context, state) {
        final id = state.uri.queryParameters['id'];
        return StoreSetupScreen(storeId: id);
      },
    ),
    GoRoute(
      path: '/seller/subscription',
      name: 'subscription',
      builder: (context, state) => const SubscriptionPlansScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
