import 'package:cloud_firestore/cloud_firestore.dart';

class ChatHelper {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<String> createOrGetChat(String userId, String peerId) async {
    final chats = await _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .get();

    for (var doc in chats.docs) {
      List participants = doc['participants'];
      if (participants.contains(peerId)) {
        return doc.id;
      }
    }

    final chatRef = await _db.collection('chats').add({
      'participants': [userId, peerId],
      'lastMessage': '',
      'lastTimestamp': FieldValue.serverTimestamp(),
    });

    return chatRef.id;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getUserChats(String userId) {
    return _db
        .collection('chats')
        .where('participants', arrayContains: userId)
        .orderBy('lastTimestamp', descending: true)
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(String chatId) {
    return _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  static Future<void> sendMessage(
    String chatId,
    String senderId,
    String recipientId,
    String message,
  ) async {
    await _db.collection('chats').doc(chatId).collection('messages').add({
      'senderId': senderId,
      'recipientId': recipientId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false,
    });

    await _db.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastTimestamp': FieldValue.serverTimestamp(),
    });
  }

  
  static Future<void> deleteMessage(String chatId, String messageId) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }

  
  static Future<void> editMessage(
      String chatId, String messageId, String newMessage) async {
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .doc(messageId)
        .update({
      'message': newMessage,
      'edited': true,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    final unreadMessages = await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .where('recipientId', isEqualTo: currentUserId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'read': true});
    }
  }
}
