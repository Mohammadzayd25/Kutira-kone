import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kutira_kone/models/product_model.dart';
import 'package:kutira_kone/theme/app_theme.dart';
import 'package:kutira_kone/routes/routes.dart';

class ArtisanProductsScreen extends StatefulWidget {
  const ArtisanProductsScreen({super.key});

  @override
  State<ArtisanProductsScreen> createState() => _ArtisanProductsScreenState();
}

class _ArtisanProductsScreenState extends State<ArtisanProductsScreen> {
  List<ProductModel> _products = List.from(demoProducts.take(3).toList());

  void _deleteProduct(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Product', style: TextStyle(fontWeight: FontWeight.w900)),
        content: const Text('Are you sure you want to delete this product?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() => _products.removeWhere((p) => p.id == id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Product deleted'),
                backgroundColor: Color(0xFFDC2626),
                behavior: SnackBarBehavior.floating,
              ));
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626), minimumSize: const Size(80, 40)),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('My Products')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push(Routes.addProduct),
        backgroundColor: AppTheme.charcoal,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
      body: _products.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade300),
                const SizedBox(height: 16),
                const Text('No products yet', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                const Text('Tap + to add your first product', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
              ],
            ),
          )
        : ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: _products.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final p = _products[i];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                      child: p.imageUrl != null
                        ? Image.network(p.imageUrl!, width: 90, height: 90, fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(width: 90, height: 90, color: AppTheme.beige))
                        : Container(width: 90, height: 90, color: AppTheme.beige),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(p.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text('₹${p.price.toInt()}/${p.unit}',
                              style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w800, fontSize: 13)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: p.stock > 5 ? const Color(0xFF059669).withOpacity(0.1) : Colors.red.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${p.stock} in stock',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: p.stock > 5 ? const Color(0xFF059669) : Colors.red,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Row(children: [
                                  const Icon(Icons.star, size: 11, color: Colors.amber),
                                  Text(' ${p.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ]),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20, color: AppTheme.charcoal),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFDC2626)),
                          onPressed: () => _deleteProduct(p.id),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
