import 'package:flutter/foundation.dart';
import 'package:social_app_ui/models/message.dart';
import 'package:social_app_ui/services/chat_service.dart';

class ConversationViewModel extends ChangeNotifier {
  ChatService chatService = ChatService();

  sendMessage(String chatId, Message message) {
    chatService.sendMessage(
      message,
      chatId,
    );
  }

  Future<String> sendFirstMessage(String recipient, Message message) async {
    String newChatId = await chatService.sendFirstMessage(
      message,
      recipient,
    );

    return newChatId;
  }
}
