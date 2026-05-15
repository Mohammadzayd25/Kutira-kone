import 'package:flutter/material.dart';
import 'package:kutira_kone/models/order_model.dart';
import 'package:kutira_kone/theme/app_theme.dart';

class ArtisanOrdersScreen extends StatefulWidget {
  const ArtisanOrdersScreen({super.key});

  @override
  State<ArtisanOrdersScreen> createState() => _ArtisanOrdersScreenState();
}

class _ArtisanOrdersScreenState extends State<ArtisanOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  List<OrderModel> _ordersFor(String tab) {
    switch (tab) {
      case 'New': return demoArtisanOrders.where((o) => o.status == OrderStatus.pending).toList();
      case 'Packed': return demoArtisanOrders.where((o) => o.status == OrderStatus.packed).toList();
      case 'Shipped': return demoArtisanOrders.where((o) => o.status == OrderStatus.shipped).toList();
      case 'Delivered': return demoArtisanOrders.where((o) => o.status == OrderStatus.delivered).toList();
      default: return demoArtisanOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Manage Orders'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.charcoal,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.gold,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          tabs: const [
            Tab(text: 'New'),
            Tab(text: 'Packed'),
            Tab(text: 'Shipped'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: ['New', 'Packed', 'Shipped', 'Delivered'].map((tab) {
          final orders = _ordersFor(tab);
          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text('No $tab orders', style: const TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => _ArtisanOrderCard(order: orders[i], tab: tab),
          );
        }).toList(),
      ),
    );
  }
}

class _ArtisanOrderCard extends StatelessWidget {
  final OrderModel order;
  final String tab;
  const _ArtisanOrderCard({required this.order, required this.tab});

  @override
  Widget build(BuildContext context) {
    final nextStatus = _nextAction(tab);
    final statusColor = _statusColor(order.status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: statusColor.withOpacity(0.1),
                child: Text(order.buyerName[0],
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.buyerName, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14)),
                    Text(order.address ?? '', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order.amount.toInt()}',
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppTheme.charcoal)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: order.paymentStatus == PaymentStatus.paid ? const Color(0xFF059669).withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      order.paymentStatus == PaymentStatus.paid ? '✓ Paid' : 'Pending',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: order.paymentStatus == PaymentStatus.paid ? const Color(0xFF059669) : Colors.orange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 6),
              Text('${order.productTitle} × ${order.quantity} ${order.unit}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('Order #${order.orderId}', style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
            ],
          ),
          if (nextStatus != null) ...[
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('✅ Order marked as ${nextStatus.label}'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFF059669),
                )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: statusColor,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text('Mark as ${nextStatus.label}',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Color _statusColor(OrderStatus s) {
    switch (s) {
      case OrderStatus.pending: return const Color(0xFFF59E0B);
      case OrderStatus.packed: return const Color(0xFF8B5CF6);
      case OrderStatus.shipped: return const Color(0xFF06B6D4);
      case OrderStatus.delivered: return const Color(0xFF059669);
      default: return AppTheme.charcoal;
    }
  }

  _StatusLabel? _nextAction(String tab) {
    switch (tab) {
      case 'New': return _StatusLabel('Packed', OrderStatus.packed);
      case 'Packed': return _StatusLabel('Shipped', OrderStatus.shipped);
      case 'Shipped': return _StatusLabel('Delivered', OrderStatus.delivered);
      default: return null;
    }
  }
}

class _StatusLabel {
  final String label;
  final OrderStatus status;
  const _StatusLabel(this.label, this.status);
}
