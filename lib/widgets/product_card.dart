import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../providers/cart_provider.dart';
import '../providers/wishlist_provider.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback? onTap;
  const ProductCard({super.key, required this.product, this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // Removed local _loved state as we use WishlistProvider now


  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();
    final isFavorite = wishlist.isFavorite(widget.product.id);
    final p = widget.product;
    Color badgeBg = AppColors.primary;
    Color badgeFg = AppColors.backgroundDark;
    if (p.badge != null && p.badge!.startsWith('Sale')) {
      badgeBg = Colors.red;
      badgeFg = Colors.white;
    }

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.transparent),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Image
          Expanded(
            child: Stack(children: [
              Positioned.fill(
                child: Image.network(p.imageUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.primary.withOpacity(0.15),
                    child: const Icon(Icons.image, color: AppColors.primary, size: 48),
                  )),
              ),
              // Favorite
              Positioned(
                top: 8, right: 8,
                child: GestureDetector(
                  onTap: () => wishlist.toggleFavorite(p),
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 16,
                      color: isFavorite ? Colors.red : Colors.white,
                    ),
                  ),
                ),
              ),
              // Badge
              if (p.badge != null)
                Positioned(
                  bottom: 8, left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: badgeBg, borderRadius: BorderRadius.circular(5)),
                    child: Text(p.badge!, style: TextStyle(color: badgeFg, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ]),
          ),
          // Info
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(p.brand, style: const TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const SizedBox(height: 2),
              Text(p.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
              const SizedBox(height: 3),
              Row(children: [
                const Icon(Icons.star, color: AppColors.primary, size: 12),
                const SizedBox(width: 3),
                Text('${p.rating} (${p.reviewCount})', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
              ]),
              const SizedBox(height: 6),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(cart.formatPrice(p.price), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                  if (p.originalPrice != null)
                    Text(cart.formatPrice(p.originalPrice!),
                      style: const TextStyle(color: Color(0xFF64748B), fontSize: 10, decoration: TextDecoration.lineThrough)),
                ]),
                GestureDetector(
                  onTap: () {
                    cart.addToCart(p);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${p.name} added to cart'), backgroundColor: AppColors.primary,
                        duration: const Duration(seconds: 1), behavior: SnackBarBehavior.floating));
                  },
                  child: Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.add_shopping_cart, size: 16, color: AppColors.backgroundDark),
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
    );
  }
}
