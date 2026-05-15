import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _qty = 1;
  bool _inWishlist = false;
  bool _addedToCart = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final totalPrice = p.price * _qty;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          // Hero image sliver
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppTheme.cream,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_rounded, size: 20, color: AppTheme.charcoal),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                  child: Icon(
                    _inWishlist ? Icons.favorite_rounded : Icons.favorite_border,
                    size: 20,
                    color: _inWishlist ? Colors.red : AppTheme.charcoal,
                  ),
                ),
                onPressed: () {
                  setState(() => _inWishlist = !_inWishlist);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(_inWishlist ? '❤️ Added to wishlist' : 'Removed from wishlist'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ));
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: p.imageUrl != null
                ? Image.network(p.imageUrl!, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: AppTheme.beige))
                : Container(color: AppTheme.beige,
                    child: const Center(child: Icon(Icons.texture, size: 80, color: AppTheme.textSecondary))),
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge + rating
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(p.category,
                          style: const TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const Spacer(),
                      Row(children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${p.rating} (${p.reviewCount} reviews)',
                          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      ]),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Title & price
                  Text(p.title,
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 24, height: 1.2, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text('by ${p.sellerName}',
                    style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700, fontSize: 14)),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Text('₹${p.price.toInt()}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: AppTheme.charcoal)),
                      Text(' / ${p.unit}',
                        style: const TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  const Text('Description', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 8),
                  Text(p.description,
                    style: const TextStyle(color: AppTheme.textSecondary, height: 1.6, fontSize: 14)),
                  const SizedBox(height: 24),

                  // Stock
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 16, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text('${p.stock} ${p.unit}s in stock',
                        style: TextStyle(
                          color: p.stock < 5 ? Colors.red : const Color(0xFF059669),
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        )),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Quantity selector
                  const Text('Quantity', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _QtyButton(
                        icon: Icons.remove,
                        onTap: () { if (_qty > 1) setState(() => _qty--); },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text('$_qty',
                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
                      ),
                      _QtyButton(
                        icon: Icons.add,
                        onTap: () { if (_qty < p.stock) setState(() => _qty++); },
                      ),
                      const Spacer(),
                      Text('Total: ₹${totalPrice.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: AppTheme.charcoal)),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text('💬 Opening chat with seller...'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ));
                          },
                          icon: const Icon(Icons.chat_bubble_outline, size: 16),
                          label: const Text('Contact Seller'),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppTheme.charcoal),
                            foregroundColor: AppTheme.charcoal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => _addedToCart = true);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('🛒 $_qty ${p.unit}(s) of ${p.title} added to cart!'),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: const Color(0xFF059669),
                            ));
                          },
                          icon: Icon(_addedToCart ? Icons.check_circle : Icons.shopping_cart_outlined, size: 16),
                          label: Text(_addedToCart ? 'Added!' : 'Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _addedToCart ? const Color(0xFF059669) : AppTheme.charcoal,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: AppTheme.beige,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 18, color: AppTheme.charcoal),
      ),
    );
  }
}
