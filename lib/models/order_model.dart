enum OrderStatus { pending, active, packed, shipped, delivered, cancelled }
enum PaymentStatus { pending, paid, refunded }

class OrderModel {
  final String orderId;
  final String buyerId;
  final String buyerName;
  final String sellerId;
  final String productId;
  final String productTitle;
  final String? productImage;
  final double amount;
  final int quantity;
  final String unit;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final DateTime createdAt;
  final String? trackingId;
  final String? address;

  const OrderModel({
    required this.orderId,
    required this.buyerId,
    required this.buyerName,
    required this.sellerId,
    required this.productId,
    required this.productTitle,
    this.productImage,
    required this.amount,
    this.quantity = 1,
    this.unit = 'meter',
    required this.status,
    this.paymentStatus = PaymentStatus.paid,
    required this.createdAt,
    this.trackingId,
    this.address,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending: return 'Pending';
      case OrderStatus.active: return 'Active';
      case OrderStatus.packed: return 'Packed';
      case OrderStatus.shipped: return 'Shipped';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
    }
  }
}

// Demo orders for Tailor (buyer perspective)
final List<OrderModel> demoTailorOrders = [
  OrderModel(
    orderId: 'ORD-001',
    buyerId: 'tailor_1',
    buyerName: 'Ramesh Kumar',
    sellerId: 'artisan_1',
    productId: 'p1',
    productTitle: 'Premium Banarasi Silk',
    productImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    amount: 4800,
    quantity: 2,
    status: OrderStatus.shipped,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    trackingId: 'TRK789123',
    address: '123 MG Road, Bengaluru',
  ),
  OrderModel(
    orderId: 'ORD-002',
    buyerId: 'tailor_1',
    buyerName: 'Ramesh Kumar',
    sellerId: 'artisan_2',
    productId: 'p2',
    productTitle: 'Organic Khadi Cotton',
    productImage: 'https://images.unsplash.com/photo-1616627561950-9f746e330187?w=400',
    amount: 1300,
    quantity: 2,
    status: OrderStatus.delivered,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
    address: '123 MG Road, Bengaluru',
  ),
  OrderModel(
    orderId: 'ORD-003',
    buyerId: 'tailor_1',
    buyerName: 'Ramesh Kumar',
    sellerId: 'artisan_3',
    productId: 'p4',
    productTitle: 'Block Print Linen',
    amount: 880,
    status: OrderStatus.pending,
    paymentStatus: PaymentStatus.pending,
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    address: '123 MG Road, Bengaluru',
  ),
  OrderModel(
    orderId: 'ORD-004',
    buyerId: 'tailor_1',
    buyerName: 'Ramesh Kumar',
    sellerId: 'artisan_4',
    productId: 'p5',
    productTitle: 'Raw Tussar Silk',
    amount: 3600,
    quantity: 2,
    status: OrderStatus.cancelled,
    paymentStatus: PaymentStatus.refunded,
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
    address: '123 MG Road, Bengaluru',
  ),
];

// Demo orders for Artisan (seller perspective)
final List<OrderModel> demoArtisanOrders = [
  OrderModel(
    orderId: 'ORD-A01',
    buyerId: 'tailor_1',
    buyerName: 'Ramesh Kumar',
    sellerId: 'artisan_1',
    productId: 'p1',
    productTitle: 'Premium Banarasi Silk',
    productImage: 'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    amount: 4800,
    quantity: 2,
    status: OrderStatus.shipped,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
    trackingId: 'TRK789123',
    address: '123 MG Road, Bengaluru',
  ),
  OrderModel(
    orderId: 'ORD-A02',
    buyerId: 'tailor_2',
    buyerName: 'Priya Sharma',
    sellerId: 'artisan_1',
    productId: 'p1',
    productTitle: 'Premium Banarasi Silk',
    amount: 2400,
    quantity: 1,
    status: OrderStatus.pending,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    address: '45 Park Street, Mumbai',
  ),
  OrderModel(
    orderId: 'ORD-A03',
    buyerId: 'tailor_3',
    buyerName: 'Anjali Verma',
    sellerId: 'artisan_1',
    productId: 'p3',
    productTitle: 'Chanderi Silk Cotton',
    amount: 3600,
    quantity: 3,
    status: OrderStatus.delivered,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
    address: '78 Civil Lines, Jaipur',
  ),
  OrderModel(
    orderId: 'ORD-A04',
    buyerId: 'tailor_4',
    buyerName: 'Sanjay Mehra',
    sellerId: 'artisan_1',
    productId: 'p1',
    productTitle: 'Premium Banarasi Silk',
    amount: 7200,
    quantity: 3,
    status: OrderStatus.packed,
    paymentStatus: PaymentStatus.paid,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    address: '12 Nehru Nagar, Delhi',
  ),
];
