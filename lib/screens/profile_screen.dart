import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../theme/app_theme.dart';
import '../routes/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    final user = auth.currentUser;
    final isTailor = auth.isTailor;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(title: const Text('My Profile')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(28),
              color: Colors.white,
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundColor: AppTheme.beige,
                        child: Text(
                          (user?.name.isNotEmpty ?? false) ? user!.name[0].toUpperCase() : '?',
                          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppTheme.charcoal),
                        ),
                      ),
                      Container(
                        width: 28, height: 28,
                        decoration: BoxDecoration(color: AppTheme.gold, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.camera_alt_rounded, size: 14, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(user?.name ?? 'Guest',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: AppTheme.charcoal)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '',
                    style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppTheme.gold.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.gold.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isTailor ? Icons.content_cut_rounded : Icons.storefront_rounded,
                          size: 14, color: AppTheme.gold,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isTailor ? 'Professional Tailor' : 'Fabric Artisan',
                          style: const TextStyle(color: AppTheme.gold, fontWeight: FontWeight.w800, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Options
            _Section(title: 'Orders & Payments', children: [
              _Option(icon: Icons.shopping_bag_outlined, label: 'My Orders', color: const Color(0xFF3B82F6),
                onTap: () => context.go(isTailor ? Routes.tailorOrders : Routes.artisanOrders)),
              _Option(icon: Icons.payments_outlined, label: 'Payments & Billing', color: const Color(0xFF059669), onTap: () {}),
              _Option(icon: Icons.account_balance_wallet_outlined, label: 'Earnings', color: AppTheme.gold, onTap: () {}),
            ]),

            if (!isTailor) ...[
              _Section(title: 'Shop Management', children: [
                _Option(icon: Icons.storefront_outlined, label: 'Shop Details', color: const Color(0xFF8B5CF6), onTap: () {}),
                _Option(icon: Icons.inventory_2_outlined, label: 'Inventory Settings', color: const Color(0xFFF59E0B), onTap: () {}),
              ]),
            ],

            _Section(title: 'Account', children: [
              _Option(icon: Icons.settings_outlined, label: 'Settings', color: AppTheme.textSecondary, onTap: () {}),
              _Option(icon: Icons.help_outline_rounded, label: 'Help & Support', color: AppTheme.textSecondary, onTap: () {}),
              _Option(
                icon: Icons.logout_rounded,
                label: 'Sign Out',
                color: const Color(0xFFDC2626),
                showChevron: false,
                onTap: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Sign Out', style: TextStyle(fontWeight: FontWeight.w900)),
                      content: const Text('Are you sure you want to sign out?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            minimumSize: const Size(80, 40),
                          ),
                          child: const Text('Sign Out'),
                        ),
                      ],
                    ),
                  );
                  if (confirm == true && context.mounted) {
                    await context.read<AuthService>().signOut();
                  }
                },
              ),
            ]),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Section({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          child: Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppTheme.textSecondary, letterSpacing: 0.5)),
        ),
        Container(
          color: Colors.white,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool showChevron;
  final VoidCallback onTap;
  const _Option({required this.icon, required this.label, required this.color, required this.onTap, this.showChevron = true});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 14),
            Text(label, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: label == 'Sign Out' ? const Color(0xFFDC2626) : AppTheme.charcoal)),
            if (showChevron) ...[
              const Spacer(),
              const Icon(Icons.chevron_right_rounded, size: 20, color: AppTheme.textSecondary),
            ],
          ],
        ),
      ),
    );
  }
}
