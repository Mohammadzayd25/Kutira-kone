import 'package:flutter/material.dart';
import 'package:kutira_kone/models/order_model.dart';
import 'package:kutira_kone/theme/app_theme.dart';

class TailorOrdersScreen extends StatefulWidget {
  const TailorOrdersScreen({super.key});

  @override
  State<TailorOrdersScreen> createState() => _TailorOrdersScreenState();
}

class _TailorOrdersScreenState extends State<TailorOrdersScreen> with SingleTickerProviderStateMixin {
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
      case 'Active': return demoTailorOrders.where((o) => o.status == OrderStatus.active || o.status == OrderStatus.shipped || o.status == OrderStatus.packed).toList();
      case 'Pending': return demoTailorOrders.where((o) => o.status == OrderStatus.pending).toList();
      case 'Completed': return demoTailorOrders.where((o) => o.status == OrderStatus.delivered).toList();
      case 'Cancelled': return demoTailorOrders.where((o) => o.status == OrderStatus.cancelled).toList();
      default: return demoTailorOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: AppTheme.charcoal,
          unselectedLabelColor: AppTheme.textSecondary,
          indicatorColor: AppTheme.gold,
          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Pending'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: ['Active', 'Pending', 'Completed', 'Cancelled']
          .map((tab) => _OrderList(orders: _ordersFor(tab), isBuyerView: true))
          .toList(),
      ),
    );
  }
}

class _OrderList extends StatelessWidget {
  final List<OrderModel> orders;
  final bool isBuyerView;
  const _OrderList({required this.orders, this.isBuyerView = true});

  @override
  Widget build(BuildContext context) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            const Text('No orders here', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) => _OrderCard(order: orders[i], isBuyerView: isBuyerView),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final bool isBuyerView;
  const _OrderCard({required this.order, this.isBuyerView = true});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending: return const Color(0xFFF59E0B);
      case OrderStatus.active: return const Color(0xFF3B82F6);
      case OrderStatus.packed: return const Color(0xFF8B5CF6);
      case OrderStatus.shipped: return const Color(0xFF06B6D4);
      case OrderStatus.delivered: return const Color(0xFF059669);
      case OrderStatus.cancelled: return const Color(0xFFDC2626);
    }
  }

  IconData get _statusIcon {
    switch (order.status) {
      case OrderStatus.pending: return Icons.schedule_rounded;
      case OrderStatus.active: return Icons.autorenew_rounded;
      case OrderStatus.packed: return Icons.inventory_rounded;
      case OrderStatus.shipped: return Icons.local_shipping_outlined;
      case OrderStatus.delivered: return Icons.check_circle_rounded;
      case OrderStatus.cancelled: return Icons.cancel_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Product image
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: order.productImage != null
                    ? Image.network(order.productImage!, width: 64, height: 64, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(width: 64, height: 64, color: AppTheme.beige))
                    : Container(width: 64, height: 64, color: AppTheme.beige,
                        child: const Icon(Icons.texture, color: AppTheme.textSecondary)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(order.productTitle,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Text(
                        isBuyerView ? 'Qty: ${order.quantity} ${order.unit}' : 'From: ${order.buyerName}',
                        style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text('₹${order.amount.toInt()}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: AppTheme.charcoal)),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_statusIcon, size: 12, color: _statusColor),
                      const SizedBox(width: 4),
                      Text(order.statusLabel,
                        style: TextStyle(color: _statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Text('Order #${order.orderId}',
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                const Spacer(),
                if (order.trackingId != null) ...[
                  const Icon(Icons.local_shipping_outlined, size: 13, color: AppTheme.textSecondary),
                  const SizedBox(width: 4),
                  Text(order.trackingId!, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                ],
                if (order.status == OrderStatus.delivered)
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(minimumSize: Size.zero, padding: EdgeInsets.zero),
                    child: const Text('Rate & Review', style: TextStyle(color: AppTheme.gold, fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
