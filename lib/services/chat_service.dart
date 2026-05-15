import 'package:flutter/foundation.dart';
import '../models/chat.dart';

class ChatService extends ChangeNotifier {
  final List<Chat> _chats = [];
  bool _isLoading = false;

  List<Chat> get chats => List.unmodifiable(_chats);
  bool get isLoading => _isLoading;

  Chat? getChat(String chatId) {
    try {
      return _chats.firstWhere((c) => c.id == chatId);
    } catch (_) {
      return null;
    }
  }

  List<Chat> getChatsForUser(String userId) =>
      _chats.where((c) => c.buyerId == userId || c.sellerId == userId).toList();

  Chat? getOrCreateChat(String listingId, String buyerId, String sellerId,
      String listingTitle) {
    try {
      return _chats.firstWhere(
          (c) => c.listingId == listingId && c.buyerId == buyerId);
    } catch (_) {
      final chat = Chat(
        id: 'chat_${DateTime.now().millisecondsSinceEpoch}',
        listingId: listingId,
        buyerId: buyerId,
        sellerId: sellerId,
        listingTitle: listingTitle,
      );
      _chats.insert(0, chat);
      notifyListeners();
      return chat;
    }
  }

  Future<void> sendMessage(
      String chatId, String senderId, String receiverId, String message) async {
    final index = _chats.indexWhere((c) => c.id == chatId);
    if (index == -1) return;

    final chat = _chats[index];
    final msg = ChatMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      senderId: senderId,
      receiverId: receiverId,
      message: message,
    );

    _chats[index] = Chat(
      id: chat.id,
      listingId: chat.listingId,
      buyerId: chat.buyerId,
      sellerId: chat.sellerId,
      listingTitle: chat.listingTitle,
      lastMessage: message,
      lastMessageTime: DateTime.now(),
      messages: [...chat.messages, msg],
    );
    notifyListeners();
  }
}
