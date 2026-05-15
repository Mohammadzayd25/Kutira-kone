class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime timestamp;
  final bool isRead;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    DateTime? timestamp,
    this.isRead = false,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toMap() => {
        'id': id,
        'chatId': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': timestamp.toIso8601String(),
        'isRead': isRead,
      };

  factory ChatMessage.fromMap(Map<String, dynamic> map) => ChatMessage(
        id: map['id'] ?? '',
        chatId: map['chatId'] ?? '',
        senderId: map['senderId'] ?? '',
        receiverId: map['receiverId'] ?? '',
        message: map['message'] ?? '',
        timestamp: DateTime.tryParse(map['timestamp'] ?? ''),
        isRead: map['isRead'] ?? false,
      );
}

class Chat {
  final String id;
  final String listingId;
  final String buyerId;
  final String sellerId;
  final String listingTitle;
  final String lastMessage;
  final DateTime lastMessageTime;
  final List<ChatMessage> messages;

  Chat({
    required this.id,
    required this.listingId,
    required this.buyerId,
    required this.sellerId,
    this.listingTitle = '',
    this.lastMessage = '',
    DateTime? lastMessageTime,
    this.messages = const [],
  }) : lastMessageTime = lastMessageTime ?? DateTime.now();
}
