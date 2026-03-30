import 'package:flutter/material.dart';
import 'home_page.dart';
import 'is_staj_page.dart';
import 'mentor_profil.dart';
import 'etkinlikler_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'chat_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MentorBulPage extends StatefulWidget {
  const MentorBulPage({super.key});

  @override
  State<MentorBulPage> createState() => _MentorBulPageState();
}

class _MentorBulPageState extends State<MentorBulPage> {
  final TextEditingController _searchController = TextEditingController();

  // Mentor Bul sayfası Navigasyonda 3. sırada (0: Chat, 1: Etkinlik, 2: Home, 3: Mentor, 4: İş)
  final int _currentIndex = 3;

  // Navigasyon Yönlendirmeleri
  void _onItemTapped(int index) {
    if (index == _currentIndex) return; // Zaten bu sayfadaysak işlem yapma
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
    }
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EtkinliklerPage()),
      );
    }
    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MentorBulPage()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const IsStajPage()),
      );
    }
    // Diğer sayfalar (Chat, Etkinlik) eklendiğinde buraya else if ile ekleyebilirsin.
  }

  String _arama = '';
  Stream<List<Map<String, dynamic>>> getMentorlerStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .where('mentorApproved', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['uid'] = doc.id;
            return data;
          }).toList();
        });
  }

  @override
  Widget build(BuildContext context) {
    // Arama filtresi

    return Scaffold(
      backgroundColor: Colors.white,

      // 🔹 ÜST BAR
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Mentor Bul',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),

      // 🔹 ANA İÇERİK
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            // 🔍 Arama kutusu
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _arama = v),
                    decoration: InputDecoration(
                      hintText: 'İsim, yetenek veya şirket adına göre ara',
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black26),
                  ),
                  child: const Icon(Icons.filter_list),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🔹 GRID
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: getMentorlerStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Mentorlar yüklenirken hata oluştu'),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Henüz onaylı mentor bulunmuyor'),
                    );
                  }

                  final tumMentorler = snapshot.data!;

                  final filtreliListe = tumMentorler.where((m) {
                    final q = _arama.toLowerCase();
                    if (q.isEmpty) return true;

                    final isim = (m['name'] ?? '').toString().toLowerCase();
                    final unvan = (m['unvan'] ?? '').toString().toLowerCase();
                    final sirket = (m['sirket'] ?? '').toString().toLowerCase();
                    final aciklama = (m['aciklama'] ?? '')
                        .toString()
                        .toLowerCase();

                    return isim.contains(q) ||
                        unvan.contains(q) ||
                        sirket.contains(q) ||
                        aciklama.contains(q);
                  }).toList();

                  if (filtreliListe.isEmpty) {
                    return const Center(
                      child: Text('Aramaya uygun mentor bulunamadı'),
                    );
                  }

                  return GridView.builder(
                    itemCount: filtreliListe.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.68,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                    itemBuilder: (context, index) {
                      final mentor = filtreliListe[index];

                      return _MentorKart(
                        mentor: {
                          'uid': mentor['uid']?.toString() ?? '',
                          'isim': mentor['name']?.toString() ?? '',
                          'unvan': mentor['unvan']?.toString() ?? '',
                          'sirket': mentor['sirket']?.toString() ?? '',
                          'yil': mentor['yil']?.toString() ?? '',
                          'aciklama': mentor['aciklama']?.toString() ?? '',
                          'mail': mentor['email']?.toString() ?? '',
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ALT BAR (ORTAK WIDGET KULLANIYOR)
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

// -------------------- MENTOR KARTI --------------------

class _MentorKart extends StatelessWidget {
  final Map<String, String> mentor;

  const _MentorKart({required this.mentor});

  String _generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  Future<void> _sendMentorlukTalebi(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Önce giriş yapmalısın')));
        return;
      }

      final mentorId = mentor['uid'] ?? '';

      if (mentorId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mentor bilgisi alınamadı')),
        );
        return;
      }

      if (mentorId == currentUser.uid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kendine talep gönderemezsin')),
        );
        return;
      }

      final chatId = _generateChatId(currentUser.uid, mentorId);

      final chatRef = FirebaseFirestore.instance
          .collection('chats')
          .doc(chatId);

      final chatDoc = await chatRef.get();

      // Chat yoksa oluştur
      if (!chatDoc.exists) {
        await chatRef.set({
          'participants': [currentUser.uid, mentorId],
          'createdAt': Timestamp.now(),
        });
      }

      // 🔥 HER ZAMAN mesaj gönder
      await chatRef.collection('messages').add({
        'senderId': currentUser.uid,
        'text': 'Merhaba iletişime geçebilir miyiz?',
        'timestamp': Timestamp.now(), // ✅ DOĞRU
        'isRead': false,
      });

      // 🔥 son mesajı güncelle
      await chatRef.update({
        'lastMessage': 'Merhaba iletişime geçebilir miyiz?',
        'lastMessageAt': Timestamp.now(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mentorluk talebi gönderildi')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Hata oluştu: $e')));
    }
  }

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, size: 40, color: Colors.white),
          ),
          const SizedBox(height: 10),

          Text(
            mentor['isim'] ?? "",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 4),
          Text(
            '${mentor['yil']} - ${mentor['unvan']} @ ${mentor['sirket']}',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),

          const SizedBox(height: 4),
          Text(
            mentor['aciklama'] ?? "",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),

          const Spacer(),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MentorProfilPage(
                      isim: mentor['isim'] ?? "",
                      unvan: mentor['unvan'] ?? "",
                      sirket: mentor['sirket'] ?? "",
                      yil: mentor['yil'] ?? "",
                      aciklama: mentor['aciklama'] ?? "",
                      fotoUrl: "",
                      linkedin: "",
                      github: "",
                      hakkinda: mentor['aciklama'] ?? "",
                      yetkinlikler: const [],
                      iletisim: mentor['mail'] ?? "",
                    ),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text('Profili Gör', style: TextStyle(fontSize: 11)),
            ),
          ),

          const SizedBox(height: 6),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await _sendMentorlukTalebi(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Mentorluk Talebi Gönder',
                style: TextStyle(fontSize: 11, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
