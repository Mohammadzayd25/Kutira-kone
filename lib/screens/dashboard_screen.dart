import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';


class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isTailor = auth.isTailor;
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context, auth),
          SliverToBoxAdapter(child: _buildHero(isTailor)),
          SliverToBoxAdapter(child: _buildStats(isTailor)),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverToBoxAdapter(
              child: Text(
                isTailor ? 'Featured Collections' : 'Popular Materials',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _buildFeaturedCard(index, isTailor),
                childCount: 4,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AuthService auth) {
    return SliverAppBar(
      backgroundColor: AppTheme.cream,
      floating: true,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: AppTheme.charcoal, borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.texture, color: AppTheme.gold, size: 20),
          ),
          const SizedBox(width: 12),
          const Text('KUTIRA KONE'),
        ],
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none_outlined)),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildHero(bool isTailor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.charcoal,
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: const NetworkImage('https://images.unsplash.com/photo-1558591710-4b4a1ae0f04d?auto=format&fit=crop&q=80&w=1000'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(color: AppTheme.gold, borderRadius: BorderRadius.circular(8)),
            child: Text(
              isTailor ? 'PREMIUM TAILORING' : 'ARTISAN HUB',
              style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            isTailor ? 'Custom Tailoring\nMade Easy' : 'Showcase Your\nCraft to the World',
            style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900, height: 1.1),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.gold, minimumSize: const Size(120, 44)),
            child: const Text('Explore Now', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _buildStats(bool isTailor) {
    final stats = isTailor 
      ? [('12k+', 'Fabrics'), ('3.5k+', 'Tailors'), ('25k+', 'Orders')]
      : [('50k+', 'Orders'), ('10k+', 'Products'), ('4.8', 'Rating')];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: stats.map((s) => Column(
          children: [
            Text(s.$1, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 20, color: AppTheme.charcoal)),
            Text(s.$2, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
          ],
        )).toList(),
      ),
    );
  }

  Widget _buildFeaturedCard(int index, bool isTailor) {
    final labels = isTailor 
      ? ['Trending Fabrics', 'Popular Tailors', 'Latest Designs', 'Bridal Collection']
      : ['Handmade Cotton', 'Silk Patterns', 'Linen Textures', 'Artisan Story'];
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.beige,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Center(child: Icon(Icons.image_outlined, color: AppTheme.textSecondary)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(labels[index], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                const Text('Premium quality', style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
