import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../routes/routes.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final isTailor = auth.isTailor;

    final List<_NavItem> items = isTailor
      ? [
          _NavItem(Routes.home, Icons.home_rounded, Icons.home_outlined, 'Home'),
          _NavItem(Routes.browse, Icons.search_rounded, Icons.search_outlined, 'Browse'),
          _NavItem(Routes.tailorOrders, Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Orders'),
          _NavItem(Routes.tailorAnalytics, Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analytics'),
          _NavItem(Routes.profile, Icons.person_rounded, Icons.person_outlined, 'Profile'),
        ]
      : [
          _NavItem(Routes.home, Icons.home_rounded, Icons.home_outlined, 'Home'),
          _NavItem(Routes.artisanProducts, Icons.inventory_2_rounded, Icons.inventory_2_outlined, 'Products'),
          _NavItem(Routes.artisanOrders, Icons.list_alt_rounded, Icons.list_alt_outlined, 'Orders'),
          _NavItem(Routes.artisanAnalytics, Icons.analytics_rounded, Icons.analytics_outlined, 'Analytics'),
          _NavItem(Routes.profile, Icons.person_rounded, Icons.person_outlined, 'Profile'),
        ];

    final selectedIndex = _getSelectedIndex(context, items);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -8))],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isSelected = selectedIndex == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.go(item.route),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? AppTheme.gold.withOpacity(0.12) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isSelected ? item.filledIcon : item.outlineIcon,
                          color: isSelected ? AppTheme.gold : AppTheme.textSecondary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                          color: isSelected ? AppTheme.charcoal : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  int _getSelectedIndex(BuildContext context, List<_NavItem> items) {
    final loc = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < items.length; i++) {
      if (loc == items[i].route || loc.startsWith('${items[i].route}/')) return i;
    }
    return 0;
  }
}

class _NavItem {
  final String route;
  final IconData filledIcon;
  final IconData outlineIcon;
  final String label;
  const _NavItem(this.route, this.filledIcon, this.outlineIcon, this.label);
}