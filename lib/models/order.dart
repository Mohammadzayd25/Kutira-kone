enum OrderType { buy, swap }
enum OrderStatus { pending, accepted, completed, cancelled }

class Order {
  final String id;
  final String listingId;
  final String buyerId;
  final String sellerId;
  final double amount;
  final OrderType type;
  final OrderStatus status;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    required this.amount,
    this.type = OrderType.buy,
    this.status = OrderStatus.pending,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'listingId': listingId,
        'buyerId': buyerId,
        'sellerId': sellerId,
        'amount': amount,
        'type': type.name,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Order.fromMap(Map<String, dynamic> map) => Order(
        id: map['id'] ?? '',
        listingId: map['listingId'] ?? '',
        buyerId: map['buyerId'] ?? '',
        sellerId: map['sellerId'] ?? '',
        amount: (map['amount'] ?? 0).toDouble(),
        type: OrderType.values.firstWhere((e) => e.name == map['type']),
        status: OrderStatus.values.firstWhere((e) => e.name == map['status']),
        createdAt: DateTime.tryParse(map['createdAt'] ?? ''),
      );
}
