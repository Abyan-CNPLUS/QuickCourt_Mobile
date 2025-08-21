import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final List<String> participants; // uid user2 orang
  final DateTime createdAt;
  final String lastMessage;
  final DateTime lastMessageTime;

  Chat({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.lastMessage,
    required this.lastMessageTime,
  });

  factory Chat.fromMap(String id, Map<String, dynamic> map) {
    return Chat(
      id: id,
      participants: List<String>.from(map['participants'] ?? []),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
      lastMessage: map['lastMessage'] ?? '',
      lastMessageTime: (map['lastMessageTime'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'participants': participants,
      'createdAt': createdAt,
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime,
    };
  }
}
