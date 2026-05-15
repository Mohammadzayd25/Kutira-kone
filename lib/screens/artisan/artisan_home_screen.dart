import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:kutira_kone/services/auth_service.dart';
import 'package:kutira_kone/models/product_model.dart';
import 'package:kutira_kone/theme/app_theme.dart';
import 'package:kutira_kone/routes/routes.dart';

class ArtisanHomeScreen extends StatelessWidget {
  const ArtisanHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final name = auth.currentUser?.name.split(' ').first ?? 'Artisan';

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, name),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            sliver: SliverToBoxAdapter(child: _buildStatsRow()),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            sliver: SliverToBoxAdapter(child: _buildQuickActions(context)),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Your Products', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  TextButton(
                    onPressed: () => context.go(Routes.artisanProducts),
                    child: const Text('Manage All →', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ArtisanProductTile(product: demoProducts[i]),
                childCount: 3,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Recent Orders', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
                  TextButton(
                    onPressed: () => context.go(Routes.artisanOrders),
                    child: const Text('View All →', style: TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    _MiniOrderRow(name: 'Priya Sharma', product: 'Banarasi Silk ×1', status: 'Pending', color: const Color(0xFFF59E0B)),
                    const Divider(height: 16),
                    _MiniOrderRow(name: 'Sanjay Mehra', product: 'Banarasi Silk ×3', status: 'Packed', color: const Color(0xFF8B5CF6)),
                    const Divider(height: 16),
                    _MiniOrderRow(name: 'Anjali Verma', product: 'Chanderi Cotton ×3', status: 'Delivered', color: const Color(0xFF059669)),
                  ],
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(Routes.addProduct),
        backgroundColor: AppTheme.charcoal,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('Add Product', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, String name) {
    return SliverAppBar(
      backgroundColor: AppTheme.cream,
      floating: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.charcoal, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.texture, color: AppTheme.gold, size: 18),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('KUTIRA KONE', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1)),
              Text('Welcome, $name! 🪡', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(icon: const Icon(Icons.notifications_none_rounded), onPressed: () {}),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: const [
        Expanded(child: _MiniStat(label: 'Total Sales', value: '₹1.2L', color: Color(0xFF059669))),
        SizedBox(width: 12),
        Expanded(child: _MiniStat(label: 'Orders', value: '47', color: Color(0xFF3B82F6))),
        SizedBox(width: 12),
        Expanded(child: _MiniStat(label: 'Products', value: '6', color: AppTheme.gold)),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _Action('Products', Icons.inventory_2_rounded, AppTheme.gold, () => context.go(Routes.artisanProducts)),
      _Action('Orders', Icons.list_alt_rounded, const Color(0xFF059669), () => context.go(Routes.artisanOrders)),
      _Action('Analytics', Icons.bar_chart_rounded, const Color(0xFF3B82F6), () => context.go(Routes.artisanAnalytics)),
      _Action('Profile', Icons.person_rounded, const Color(0xFF8B5CF6), () => context.go(Routes.profile)),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((a) => _QuickChip(action: a)).toList(),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: color)),
          Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Action {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _Action(this.label, this.icon, this.color, this.onTap);
}

class _QuickChip extends StatelessWidget {
  final _Action action;
  const _QuickChip({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Column(
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: action.color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(action.icon, color: action.color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(action.label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _ArtisanProductTile extends StatelessWidget {
  final ProductModel product;
  const _ArtisanProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: product.imageUrl != null
              ? Image.network(product.imageUrl!, width: 60, height: 60, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(width: 60, height: 60, color: AppTheme.beige))
              : Container(width: 60, height: 60, color: AppTheme.beige),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                Text('₹${product.price.toInt()}/${product.unit} · ${product.stock} in stock',
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(icon: const Icon(Icons.edit_outlined, size: 18), onPressed: () {}, color: AppTheme.charcoal),
              IconButton(icon: const Icon(Icons.delete_outline, size: 18), onPressed: () {}, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniOrderRow extends StatelessWidget {
  final String name;
  final String product;
  final String status;
  final Color color;
  const _MiniOrderRow({required this.name, required this.product, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: color.withOpacity(0.1),
          child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
              Text(product, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
          child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
