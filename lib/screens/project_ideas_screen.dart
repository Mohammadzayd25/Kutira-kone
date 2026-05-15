import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Simulated DIY project ideas for artisans using fabric scraps.
class ProjectIdeasScreen extends StatelessWidget {
  const ProjectIdeasScreen({super.key});

  static const List<_ProjectIdea> _ideas = [
    _ProjectIdea(
      title: 'Patchwork Face Masks',
      description: 'Combine cotton scraps of at least 0.1m each to stitch reusable face masks.',
      minQuantity: '0.1 m',
      materials: [FabricHint.cotton, FabricHint.linen],
      icon: Icons.face_retouching_natural,
      color: Color(0xFF10B981),
    ),
    _ProjectIdea(
      title: 'Fabric Coin Pouches',
      description: 'Small zipper pouches from silk or cotton remnants. Great gifting item.',
      minQuantity: '0.2 m',
      materials: [FabricHint.silk, FabricHint.cotton],
      icon: Icons.wallet,
      color: Color(0xFF8B5CF6),
    ),
    _ProjectIdea(
      title: 'Denim Tote Bag',
      description: 'Sturdy tote bags made from denim cut-offs. Zero sewing machine required.',
      minQuantity: '0.5 m',
      materials: [FabricHint.denim],
      icon: Icons.shopping_bag_outlined,
      color: Color(0xFF3B82F6),
    ),
    _ProjectIdea(
      title: 'Soft Fabric Dolls',
      description: 'Handmade stuffed dolls from mixed fabric scraps — a village craft tradition.',
      minQuantity: '0.3 m',
      materials: [FabricHint.cotton, FabricHint.velvet],
      icon: Icons.child_care,
      color: Color(0xFFF59E0B),
    ),
    _ProjectIdea(
      title: 'Quilted Table Runner',
      description: 'Assemble colorful fabric strips into a beautiful quilted runner for your home.',
      minQuantity: '1.0 m',
      materials: [FabricHint.cotton, FabricHint.linen],
      icon: Icons.table_restaurant_outlined,
      color: Color(0xFFEF4444),
    ),
    _ProjectIdea(
      title: 'Hair Scrunchies',
      description: 'No-waste silk and cotton hair scrunchies. Sell at local markets.',
      minQuantity: '0.05 m',
      materials: [FabricHint.silk, FabricHint.velvet],
      icon: Icons.circle_outlined,
      color: Color(0xFFEC4899),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.backgroundColor,
            elevation: 0,
            title: const Text(
              'Design Ideas',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppTheme.textPrimary, fontSize: 20),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: Text(
                  'Projects you can make with small scraps',
                  style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (ctx, i) => _ProjectCard(idea: _ideas[i]),
                childCount: _ideas.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final _ProjectIdea idea;
  const _ProjectCard({required this.idea});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: idea.color.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(color: idea.color.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 8)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: idea.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(idea.icon, color: idea.color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              idea.title,
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: AppTheme.textPrimary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Text(
              idea.description,
              style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: idea.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Min: ${idea.minQuantity}',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: idea.color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectIdea {
  final String title;
  final String description;
  final String minQuantity;
  final List<FabricHint> materials;
  final IconData icon;
  final Color color;

  const _ProjectIdea({
    required this.title,
    required this.description,
    required this.minQuantity,
    required this.materials,
    required this.icon,
    required this.color,
  });
}

enum FabricHint { cotton, silk, denim, linen, velvet }
