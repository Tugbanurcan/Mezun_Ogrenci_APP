import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'chat_detail_page.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'users_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();

  late String currentUser;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser!.uid;

    print("BENİM UID: $currentUser");
  }

  String _arama = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AnaSayfa()),
            );
          },
        ),
        centerTitle: true,
        title: const Text(
          'Sohbetler',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          /// 🔍 ARAMA
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                setState(() {
                  _arama = v.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Kişi veya mesaj ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// 🔥 GERÇEK CHAT LİSTESİ
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .where('participants', arrayContains: currentUser)
                  .snapshots(),

              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final chats = snapshot.data!.docs;

                if (chats.isEmpty) {
                  return const Center(child: Text("Henüz sohbet yok"));
                }

                return ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),

                  itemBuilder: (context, index) {
                    final chat = chats[index];

                    final List participants = chat['participants'];

                    final otherUser = participants.firstWhere(
                      (u) => u != currentUser,
                    );

                    return FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(otherUser)
                          .get(),
                      builder: (context, userSnap) {
                        if (!userSnap.hasData) {
                          return const ListTile(title: Text("Yükleniyor..."));
                        }

                        final userData = userSnap.data!;
                        final name = userData['name']; // şimdilik email kullan

                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade200,
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(name),
                          subtitle: Text(chat['lastMessage'] ?? ""),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChatDetailPage(chatId: chat.id, isim: name),
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UsersPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<String> createOrGetChat(String otherUserId) async {
  final currentUser = FirebaseAuth.instance.currentUser!.uid;

  // daha önce chat var mı?
  final query = await FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: currentUser)
      .get();

  for (var doc in query.docs) {
    List users = doc['participants'];

    if (users.contains(otherUserId)) {
      return doc.id; // chat zaten var
    }
  }

  // yoksa yeni oluştur
  final newChat = await FirebaseFirestore.instance.collection('chats').add({
    'participants': [currentUser, otherUserId],
    'lastMessage': '',
    'timestamp': FieldValue.serverTimestamp(),
  });

  return newChat.id;
}
