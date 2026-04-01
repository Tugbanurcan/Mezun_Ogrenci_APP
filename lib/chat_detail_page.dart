import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';
import 'chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';

class ChatDetailPage extends StatefulWidget {
  final String chatId;
  final String isim;

  const ChatDetailPage({super.key, required this.chatId, required this.isim});

  @override
  State<ChatDetailPage> createState() => _ChatDetailPageState();
}

class _ChatDetailPageState extends State<ChatDetailPage> {
  final TextEditingController _controller = TextEditingController();
  late String currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;
    print("BENİM UID: $currentUser"); // 👈 BURAYA EKLE
  }

  void _sendMessage() async {
    final messageText = _controller.text.trim();
    if (messageText.isEmpty) return;

    _controller.clear();

    // 1. Mesajı Kaydet
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .collection('messages')
        .add({
          'text': messageText,
          'senderId': currentUser,
          'timestamp': FieldValue.serverTimestamp(),
        });

    // 2. Chat Listesi Güncellemesi
    await FirebaseFirestore.instance
        .collection('chats')
        .doc(widget.chatId)
        .update({
          'lastMessage': messageText,
          'timestamp': FieldValue.serverTimestamp(),
        });

    // 3. 🔔 BİLDİRİM GÖNDERME (SENİN SERVİSİNE UYGUN HALE GETİRİLDİ)
    try {
      final chatDoc = await FirebaseFirestore.instance
          .collection('chats')
          .doc(widget.chatId)
          .get();
      final List participants = chatDoc['participants'];
      final receiverId = participants.firstWhere((id) => id != currentUser);

      // Gönderen ismini bul
      final senderDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser)
          .get();
      final senderName = senderDoc.data()?['name'] ?? "Bir kullanıcı";

      // ✅ SENİN YAZDIĞIN SERVİSİ ÇAĞIRIYORUZ
      await NotificationService.sendNewMessage(
        receiverUserId: receiverId,
        senderName: senderName,
        conversationId: widget.chatId,
      );

      print("Bildirim başarıyla servis üzerinden gönderildi.");
    } catch (e) {
      print("Bildirim gönderilirken hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.isim, style: const TextStyle(color: Colors.black87)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Column(
        children: [
          /// MESAJLAR
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(widget.chatId)
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data = docs[index];
                    final isMe = data['senderId'] == currentUser;

                    return Align(
                      alignment: isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.deepPurple.shade200
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(data['text'] ?? ''),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// INPUT
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,

            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Mesaj yaz...",
                      border: InputBorder.none,
                    ),
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
