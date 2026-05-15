import 'package:flutter/material.dart';
import 'package:kutira_kone/theme/app_theme.dart';

class TailorAnalyticsScreen extends StatelessWidget {
  const TailorAnalyticsScreen({super.key});

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
            // Stat cards
            GridView.count(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 1.4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                _StatCard(label: 'Total Orders', value: '24', icon: Icons.shopping_bag_rounded, color: Color(0xFF3B82F6), trend: '+12%'),
                _StatCard(label: 'Monthly Spend', value: '₹42,800', icon: Icons.payments_rounded, color: Color(0xFF059669), trend: '+8%'),
                _StatCard(label: 'Fabric Saved', value: '38 m', icon: Icons.eco_rounded, color: AppTheme.gold, trend: '+5 this month'),
                _StatCard(label: 'Pending Orders', value: '3', icon: Icons.schedule_rounded, color: Color(0xFFF59E0B), trend: ''),
              ],
            ),

            const SizedBox(height: 28),
            const Text('Monthly Spending', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 16),
            const _SpendingChart(),

            const SizedBox(height: 28),
            const Text('Top Purchased Categories', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 14),
            const _CategoryBar(label: 'Silk', percentage: 0.45, color: Color(0xFF8B5CF6)),
            const SizedBox(height: 10),
            const _CategoryBar(label: 'Cotton', percentage: 0.30, color: AppTheme.gold),
            const SizedBox(height: 10),
            const _CategoryBar(label: 'Linen', percentage: 0.15, color: Color(0xFF059669)),
            const SizedBox(height: 10),
            const _CategoryBar(label: 'Others', percentage: 0.10, color: Color(0xFFF59E0B)),

            const SizedBox(height: 28),
            const Text('Recent Activity', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 14),
            ..._recentActivity.map((a) => _ActivityItem(activity: a)),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  const _StatCard({required this.label, required this.value, required this.icon, required this.color, this.trend = ''});

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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Icon(icon, color: color, size: 18),
              ),
              if (trend.isNotEmpty) ...[
                const Spacer(),
                Text(trend, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
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

class _SpendingChart extends StatelessWidget {
  const _SpendingChart();

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final values = [0.4, 0.6, 0.5, 0.8, 0.7, 0.9];

    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(months.length, (i) {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    height: (values[i] * 100).toDouble(),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppTheme.gold, AppTheme.gold.withOpacity(0.5)],
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
    );
  }
}

class _CategoryBar extends StatelessWidget {
  final String label;
  final double percentage;
  final Color color;
  const _CategoryBar({required this.label, required this.percentage, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
        const SizedBox(width: 10),
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
        Text('${(percentage * 100).toInt()}%',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}

const _recentActivity = [
  _ActivityData('Ordered 2m Banarasi Silk', 'Shipped · 3 days ago', Icons.local_shipping_outlined, Color(0xFF06B6D4)),
  _ActivityData('Paid ₹1,300 for Khadi Cotton', 'Delivered · 10 days ago', Icons.check_circle_rounded, Color(0xFF059669)),
  _ActivityData('Saved Block Print Linen to Wishlist', 'Just now', Icons.favorite_rounded, Color(0xFFEC4899)),
];

class _ActivityData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _ActivityData(this.title, this.subtitle, this.icon, this.color);
}

class _ActivityItem extends StatelessWidget {
  final _ActivityData activity;
  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: activity.color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(activity.icon, color: activity.color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                Text(activity.subtitle, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
