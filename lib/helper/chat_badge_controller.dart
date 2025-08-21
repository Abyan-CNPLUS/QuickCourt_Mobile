import 'package:flutter/material.dart';

class ChatBadgeController {

  final ValueNotifier<int> unreadCount = ValueNotifier<int>(0);


  void reset() {
    unreadCount.value = 0;
  }


  static final ChatBadgeController _instance = ChatBadgeController._internal();

  factory ChatBadgeController() {
    return _instance;
  }

  ChatBadgeController._internal();
}


final chatBadgeController = ChatBadgeController();
