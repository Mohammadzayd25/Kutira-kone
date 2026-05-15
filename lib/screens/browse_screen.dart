import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../routes/routes.dart';

class BrowseScreen extends StatefulWidget {
  const BrowseScreen({super.key});

  @override
  State<BrowseScreen> createState() => _BrowseScreenState();
}

class _BrowseScreenState extends State<BrowseScreen> {
  String _search = '';
  String _selectedCategory = 'All';
  String _sortBy = 'Popular';

  final List<String> _categories = ['All', 'Silk', 'Cotton', 'Linen', 'Ikat', 'Silk Cotton'];
  final List<String> _sortOptions = ['Popular', 'Price: Low to High', 'Price: High to Low', 'Rating'];

  List<ProductModel> get _filtered {
    var list = demoProducts;
    if (_selectedCategory != 'All') list = list.where((p) => p.category == _selectedCategory).toList();
    if (_search.isNotEmpty) list = list.where((p) => p.title.toLowerCase().contains(_search.toLowerCase()) || p.description.toLowerCase().contains(_search.toLowerCase())).toList();
    switch (_sortBy) {
      case 'Price: Low to High': list = [...list]..sort((a, b) => a.price.compareTo(b.price));
      case 'Price: High to Low': list = [...list]..sort((a, b) => b.price.compareTo(a.price));
      case 'Rating': list = [...list]..sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final products = _filtered;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: AppTheme.cream,
            floating: true,
            pinned: true,
            elevation: 0,
            title: const Text('Textile Marketplace', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20)),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.sort_rounded),
                onSelected: (v) => setState(() => _sortBy = v),
                itemBuilder: (_) => _sortOptions
                  .map((s) => PopupMenuItem(value: s, child: Text(s)))
                  .toList(),
              ),
              IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(116),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Column(
                  children: [
                    // Search bar
                    TextField(
                      onChanged: (v) => setState(() => _search = v),
                      decoration: InputDecoration(
                        hintText: 'Search cotton, silk, linen...',
                        prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary, size: 20),
                        suffixIcon: _search.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear, size: 18), onPressed: () => setState(() => _search = ''))
                          : null,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Category chips
                    SizedBox(
                      height: 32,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final cat = _categories[i];
                          final sel = _selectedCategory == cat;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedCategory = cat),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: sel ? AppTheme.charcoal : Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: sel ? AppTheme.charcoal : Colors.grey.shade200),
                              ),
                              child: Text(cat,
                                style: TextStyle(
                                  color: sel ? Colors.white : AppTheme.textSecondary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                )),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (products.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade300),
                    const SizedBox(height: 16),
                    Text('No products found for "$_search"',
                      style: const TextStyle(color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 0.68,
                ),
                delegate: SliverChildBuilderDelegate(
                  (ctx, i) => _BrowseCard(product: products[i]),
                  childCount: products.length,
                ),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }
}

class _BrowseCard extends StatelessWidget {
  final ProductModel product;
  const _BrowseCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push(Routes.productDetailPath(product.id), extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: product.imageUrl != null
                      ? Image.network(product.imageUrl!, width: double.infinity, fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(color: AppTheme.beige,
                            child: const Center(child: Icon(Icons.image_outlined, color: AppTheme.textSecondary, size: 36))))
                      : Container(color: AppTheme.beige),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      width: 30, height: 30,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.9), shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 15, color: AppTheme.charcoal),
                    ),
                  ),
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(10, 4, 10, 6),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black.withOpacity(0.5)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Text('₹${product.price.toInt()}/${product.unit}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.title,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text(product.sellerName,
                    style: const TextStyle(color: AppTheme.gold, fontSize: 10, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 11),
                      Text(' ${product.rating} (${product.reviewCount})',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
