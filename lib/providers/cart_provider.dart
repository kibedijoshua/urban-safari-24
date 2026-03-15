import 'package:flutter/foundation.dart';
import '../models/models.dart';

final List<Product> sampleProducts = [
  const Product(
    id: '1',
    brand: 'Zara Collection',
    name: 'Flowy Mustard Summer Dress',
    price: 85000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCwjdeTQEYya-WEJBmkiQmiN0jhYUJ2mNieR4vg3XQctoAuSvK56S7yCJ2PNyR71-lMKZpxgOjLWN7ibTALZIGt4qf97tV81TTUNSn-JU5SUK2GFcnMs7MYQlyj8fyAnX6f0Df9QTW0WIw5wmpMdZWou9dXUwwAoxr0AmD--Hlk2pxT_tuVT8JM3ms7m-RpGkqJotInpsWD7L-cRSwYgJ6be6GYfwWIIXVGNJI3UtvJNgL-SgchadJon16FW71hKLS1Vfq1mcg1JGe-',
    badge: 'Trending',
    rating: 4.8,
    reviewCount: 120,
  ),
  const Product(
    id: '2',
    brand: 'Essentials',
    name: 'Premium White Cotton Tee',
    price: 45000,
    originalPrice: 55000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDWJK58Xi_e3IoK3ZFiMCnugKMo3x-tNlkHrJn-s9_RKnL9Ba7ypY7rSPW8S-8EY0o8YKD449oxZpcxqWnr-FMHgcp_2Jb-mehOs_9X4HgVb58gmO-McxMK0yx3Opv6vtrG9NDZybDz_JZn1ybnjaOU7X9jan90whPkn81cDOeO4P2Q0Ty9e39chpnjM5Ni6FILGF8DdLtvuMypCdpjLfkdof-Y8AmapqNDEYSUkTx_s2boAC9IW5Edig7wU0uKUy_ujXVpLTQtwzX6',
    rating: 4.5,
    reviewCount: 85,
  ),
  const Product(
    id: '3',
    brand: 'Leather Lab',
    name: 'Classic Biker Leather Jacket',
    price: 220000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDcvXatujZ6efkgg32h7xSt2hBwVpjTnAUTjzmYge6hAJn0_0MZfSIygkbfK_ZPUM_SeFhx6zcToPt-bomIOVLdyvpk9zwoZRBznR3tFgCHvmPJ_BCwICn7ydQ7usaXGPbWhV4vdlS_GDUSKh6Ww6D-o-NW7tgGvQnUHwACzc7STl6GEh0hdMtPvhhrzEqnxR1CJubyC0CSvNsWLJRiZJjEcFY0EivmftiNCP6ksrQHxuAkBwZP5A3jVJTmMluBcRT78mDJeqFyHcZm',
    rating: 4.9,
    reviewCount: 42,
  ),
  const Product(
    id: '4',
    brand: 'Nike Sport',
    name: 'Air Max Velocity Runners',
    price: 160000,
    originalPrice: 200000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBtQL2Wopnc1eG1ANmbBn5g_TOB6wI7Atl7pmdJRPWW_DX3Vdn6ke3jl4m_YdRLeylbi9LeTIDY3oU39MLTnUpkcKwtVZg8K5UIQ3aBbTJKj9kregg5yirfY8tNDfSURsD3AqaaKEqqgfKCoO6iWTbPTYWF2p7tZzTrt3WtyybW1cKEUMyKHTUTe9mHKY_X9cTF1GR91WmG0jKTW2nFOL9eNYUCFIHS-2ungG48BQeZt1t7NhInU3ZMLSJYShe7dJYvJcFDHn7Oe_zT',
    badge: 'Sale -20%',
    rating: 4.7,
    reviewCount: 310,
  ),
  const Product(
    id: '5',
    brand: 'Boho Chic',
    name: 'Patterned Silk Wrap Blouse',
    price: 95000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuC4tOtmxPf5KdrV01YsBxVpUaPgNg5GAe6SQy1AoSlaXnNzO_5ZJ629kBqWI9ZFPHoLbmsfeqNzt7avjf6X3GbISNO_V1FS2xVZWxohr6U-YDFI2z8IjPangGoKRymUPOc7gcL_WhxXpLArQwf9leY3X-OzrD8VRfKoRSDWNMkrgetcP-pdSbfrYyWpnVD9nV5NJtQOYYZqpKAS-rleW3uccYHov2MT2nX8gSjPapX2nyuKSsdTi2gAFiRkwC4oaNGf4rhacHzfSsiw',
    rating: 4.6,
    reviewCount: 56,
  ),
  const Product(
    id: '6',
    brand: "Levi's",
    name: '511 Slim Fit Denim Jeans',
    price: 145000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuD_OklKQ_sy8z3XXDs_GPDwMyoLFc3qsnvNUud2GEYCueez_UJELEs55-bK6LWoUSevOqfrAqnQ03GEv-cZca6KgrgRw_Zq3_kHD1zs0BqS-Jr-ivcaoD38ElUtFtUHYIQmmjQ6uu5JfQyhXmbCUcdxLsVCDtOtNYq85KI6Zgc3D2Bc1Iv2K6ucakpAsS3FYjnsorhAZ2fkMX19Z5rmvopdXiIYScpukwovZW3uKa1xzjSXxJjWgnW1t5XzKuoH-dOhzQezSzWoXKLb',
    rating: 4.4,
    reviewCount: 189,
  ),
  const Product(
    id: '7',
    brand: 'H&M Studio',
    name: 'Forest Green Oversized Hoodie',
    price: 115000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuCfWcoojzmdsgiizDKM1X_DN7L7YMa8G58rNLweNMjpDt6Q2vgpH-wk5-NAo_0nk_d9dpb-wbV19ZDqLdJw3OuXvnt16HJ2RUXDvLhW6JqBxe1JDESV727nOGNNxOJRuFzRubCiVUpYNnLY9IBQtxywyav7Fx-XomayxKKlNtrVyAzUx0NiLRF15yG7fI7zoJJfv8Ti2iPzlEi84qi2-Qq6lyuQDME1C73M3ngdPseLQe3rghITdlKJqSbcDwdiEsitbXhZZp68QS8q',
    badge: 'New Arrival',
    rating: 4.8,
    reviewCount: 24,
  ),
  const Product(
    id: '8',
    brand: 'Island Vibes',
    name: 'Floral Print Linen Shorts',
    price: 65000,
    imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBjFXz7N-3WGH26DnOMg2PfbjaMDYo-u_Wpni7IgplNrL46_yBM5C8g-n7iLvMZGIL-7QZ-Xi3wZOVNpK4phRA4YJaxc02oX5rV_6G9I9eHqly8PGpPEkqeKXsBzzGWbEfyB-CR4z7IQu0tqgBBBOAlRCKyRyi42YFIIOX4WmM-GJHvmTg2wf7GPP-kY2V4SibllA6nRRYEyvHZRTbKtOB-p7LKBUUay3niFJNkfydyzYSeUepmttttYG_S_8XEFJIBli7zujGizC4F',
    rating: 4.3,
    reviewCount: 78,
  ),
];

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _items.fold(0, (sum, item) => sum + item.product.price * item.quantity);

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void increment(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrement(String productId) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  String formatPrice(int price) {
    final formatted = price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return 'UGX $formatted';
  }
}
