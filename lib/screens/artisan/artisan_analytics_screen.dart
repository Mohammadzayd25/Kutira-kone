import 'package:flutter/material.dart';
import 'package:kutira_kone/theme/app_theme.dart';

class ArtisanAnalyticsScreen extends StatelessWidget {
  const ArtisanAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('Analytics')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary stat cards
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _StatCard(label: 'Total Sales', value: '₹1.2L', icon: Icons.trending_up_rounded, color: Color(0xFF059669), trend: '+18%'),
                _StatCard(label: 'Total Orders', value: '47', icon: Icons.shopping_bag_rounded, color: Color(0xFF3B82F6), trend: '+5 this month'),
                _StatCard(label: 'Product Views', value: '3,241', icon: Icons.visibility_rounded, color: Color(0xFF8B5CF6), trend: '+32%'),
                _StatCard(label: 'Conversion', value: '14.5%', icon: Icons.auto_graph_rounded, color: AppTheme.gold, trend: '+2.1%'),
              ],
            ),

            const SizedBox(height: 28),
            const Text('Revenue (Last 6 Months)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 16),
            _buildRevenueChart(),

            const SizedBox(height: 28),
            const Text('Top Selling Products', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 14),
            _buildTopProducts(),

            const SizedBox(height: 28),
            const Text('Order Status Breakdown', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 14),
            const _StatusBar(label: 'Delivered', value: '28 orders', percentage: 0.60, color: Color(0xFF059669)),
            const SizedBox(height: 10),
            const _StatusBar(label: 'Shipped', value: '10 orders', percentage: 0.21, color: Color(0xFF06B6D4)),
            const SizedBox(height: 10),
            const _StatusBar(label: 'Packed', value: '6 orders', percentage: 0.13, color: Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            const _StatusBar(label: 'Pending', value: '3 orders', percentage: 0.06, color: Color(0xFFF59E0B)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final values = [0.35, 0.55, 0.70, 0.65, 0.80, 1.0];
    final amounts = ['18K', '28K', '38K', '35K', '46K', '56K'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(months.length, (i) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text('₹${amounts[i]}', style: const TextStyle(fontSize: 8, color: AppTheme.textSecondary, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 4),
                      Container(
                        height: (values[i] * 100).toDouble(),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF86EFAC)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(months[i], style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTopProducts() {
    final products = [
      ('Premium Banarasi Silk', '23 sold', 0.85),
      ('Organic Khadi Cotton', '14 sold', 0.52),
      ('Chanderi Silk Cotton', '10 sold', 0.37),
    ];
    return Column(
      children: products.asMap().entries.map((e) {
        final rank = e.key + 1;
        final p = e.value;
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
          ),
          child: Row(
            children: [
              Container(
                width: 30, height: 30,
                decoration: BoxDecoration(
                  color: rank == 1 ? AppTheme.gold.withOpacity(0.1) : Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text('#$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 11,
                    color: rank == 1 ? AppTheme.gold : AppTheme.textSecondary,
                  ))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.$1, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: p.$3,
                      backgroundColor: Colors.grey.shade100,
                      valueColor: AlwaysStoppedAnimation(rank == 1 ? AppTheme.gold : const Color(0xFF059669)),
                      minHeight: 4,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(p.$2, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppTheme.textSecondary)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color, required this.trend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(9)),
                child: Icon(icon, color: color, size: 16),
              ),
              const Spacer(),
              Text(trend, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppTheme.charcoal)),
          Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StatusBar extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;
  final Color color;
  const _StatusBar({required this.label, required this.value, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 70, child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))),
        const SizedBox(width: 8),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: Colors.grey.shade100,
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 10,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(width: 60, child: Text(value, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color))),
      ],
    );
  }
}
