import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat_detail_page.dart';
import 'chat_page.dart'; // createOrGetChat buradan geliyor

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kullanıcılar"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: Column(
        children: [
          /// 🔍 ARAMA
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Kullanıcı ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          /// 👥 KULLANICI LİSTESİ
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;

                if (users.isEmpty) {
                  return const Center(child: Text("Kullanıcı yok"));
                }

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    // ❌ kendini gösterme
                    if (user.id == currentUserId) {
                      return const SizedBox();
                    }

                    final name = user['name'] ?? user['email'];

                    // 🔍 arama filtresi
                    if (searchText.isNotEmpty &&
                        !name.toLowerCase().contains(searchText)) {
                      return const SizedBox();
                    }

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade200,
                        child: const Icon(Icons.person, color: Colors.white),
                      ),

                      title: Text(
                        name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),

                      trailing: const Icon(Icons.chat_bubble_outline),

                      onTap: () async {
                        String otherUserId = user.id;

                        // 🔥 CHAT OLUŞTUR / GETİR
                        String chatId = await createOrGetChat(otherUserId);

                        // 🔥 CHAT SAYFASINA GİT
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ChatDetailPage(chatId: chatId, isim: name),
                          ),
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
    );
  }
}
