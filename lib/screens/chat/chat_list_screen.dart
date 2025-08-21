import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_court_booking/helper/chat_helper.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  final String currentUserId;
  const ChatListScreen({super.key, required this.currentUserId});

  Future<String> getUsername(String userId) async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data()?['name'] ?? 'Unknown User';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Chats")),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ChatHelper.getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Belum ada chat"));
          }

          final chats = snapshot.data!.docs;

          return ListView.separated(
            itemCount: chats.length,
            separatorBuilder: (context, index) => const Divider(
              thickness: 1,
              height: 1,
              color: Colors.grey,
            ),
            itemBuilder: (context, index) {
              final chat = chats[index].data();
              final chatId = chats[index].id;

              final participants = List<String>.from(chat['participants']);
              final peerId = participants.firstWhere((id) => id != currentUserId);

              return FutureBuilder<String>(
                future: getUsername(peerId),
                builder: (context, userSnapshot) {
                  final peerName = userSnapshot.data ?? peerId;

                  return ListTile(
                    title: Text("Chat dengan $peerName"),
                    subtitle: Text(chat['lastMessage'] ?? ""),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            chatId: chatId,
                            currentUserId: currentUserId,
                            peerId: peerId,
                            peerName: peerName,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
