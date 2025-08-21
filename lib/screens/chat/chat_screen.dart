import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:quick_court_booking/helper/chat_helper.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String currentUserId;
  final String peerId;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.currentUserId,
    required this.peerId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  String? chatId;

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  Future<void> _initChat() async {
    chatId = await ChatHelper.createOrGetChat(widget.currentUserId, widget.peerId);
    setState(() {});
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    ChatHelper.sendMessage(
      widget.chatId,
      widget.currentUserId,
      _messageController.text.trim(),
    );
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (chatId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text("Chat dengan ${widget.peerId}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: ChatHelper.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                final messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index].data();
                    final isMe = msg['senderId'] == widget.currentUserId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: GestureDetector(
                        onLongPress: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return SafeArea(
                                child: Wrap(
                                  children: [
                                    if (isMe) 
                                      ListTile(
                                        leading: const Icon(Icons.edit),
                                        title: const Text('Edit'),
                                        onTap: () {
                                          Navigator.pop(context);
                                          print("Edit message tapped");
                                        },
                                      ),
                                    if (isMe)
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        title: const Text('Hapus'),
                                        onTap: () async {
                                          Navigator.pop(context);
                                          await ChatHelper.deleteMessage(widget.chatId, messages[index].id);
                                        },
                                      ),
                                    ListTile(
                                      leading: const Icon(Icons.copy),
                                      title: const Text('Copy'),
                                      onTap: () {
                                        Navigator.pop(context);
                                        final text = msg['message'] ?? "";
                                        Clipboard.setData(ClipboardData(text: text));
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text("Pesan disalin")),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(10),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.6,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[100] : Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                msg['message'] ?? "",
                                style: const TextStyle(fontSize: 16, color: Colors.black87),
                              ),
                              const SizedBox(height: 4),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                  msg['timestamp'] != null
                                      ? DateTime.fromMillisecondsSinceEpoch(
                                          (msg['timestamp'] as Timestamp).millisecondsSinceEpoch,
                                        ).toLocal().toString().substring(11, 16)
                                      : "",
                                  style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: "Tulis pesan..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
