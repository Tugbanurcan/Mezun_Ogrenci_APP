import 'package:flutter/material.dart';
import 'home_page.dart';
import 'mentor_bul_page.dart';
import 'is_staj_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'chat_page.dart';
import 'home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EtkinliklerPage extends StatefulWidget {
  const EtkinliklerPage({super.key});

  @override
  State<EtkinliklerPage> createState() => _EtkinliklerPageState();
}

class _EtkinliklerPageState extends State<EtkinliklerPage> {
  // Navigasyonda Etkinlikler indexi
  final int _currentIndex = 1;

  void _onItemTapped(int index) {
    if (index == _currentIndex) return;
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
    }

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MentorBulPage()),
      );
    } else if (index == 4) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const IsStajPage()),
      );
    }
  }

  // 🔹 Katıl
  Future<void> _katil(Map<String, String> etkinlik) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('joined_events')
        .doc(etkinlik['id'])
        .set({'joinedAt': FieldValue.serverTimestamp()});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Katıldınız 🎉')));
  }

  void _showKatildiklarim() {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(user!.uid)
              .collection('joined_events')
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final joinedIds = snapshot.data!.docs.map((e) => e.id).toList();

            if (joinedIds.isEmpty) {
              return const Center(child: Text("Hiç katıldığın etkinlik yok"));
            }

            // 🔥 ŞİMDİ EVENTS'TEN ÇEKİYORUZ
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('etkinlikler')
                  .get(),
              builder: (context, eventSnapshot) {
                if (!eventSnapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allEvents = eventSnapshot.data!.docs;

                final katildiklar = allEvents
                    .where((e) => joinedIds.contains(e.id))
                    .toList();

                return ListView.builder(
                  itemCount: katildiklar.length,
                  itemBuilder: (context, index) {
                    final e = katildiklar[index];

                    final timestamp = e['tarih'] as Timestamp;
                    final date = timestamp.toDate();

                    final formattedDate =
                        "${date.day}/${date.month}/${date.year}";

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event, color: Colors.deepPurple),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  e['baslik'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  formattedDate,
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final user = FirebaseAuth.instance.currentUser;

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user!.uid)
                                  .collection('joined_events')
                                  .doc(e.id)
                                  .delete();

                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔹 APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Etkinlikler',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_available, color: Colors.black87),
            tooltip: 'Katıldıklarım',
            onPressed: _showKatildiklarim,
          ),
        ],
      ),

      // 🔹 LİSTE
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('etkinlikler')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final etkinlikler = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: etkinlikler.length,
            itemBuilder: (context, index) {
              final data = etkinlikler[index];

              final timestamp = data['tarih'] as Timestamp;
              final date = timestamp.toDate();

              final formattedDate = "${date.day}/${date.month}/${date.year}";

              return _EtkinlikKart(
                baslik: data['baslik'],
                tarih: formattedDate,
                aciklama: data['aciklama'],
                imageUrl: data['imageUrl'] ?? "https://via.placeholder.com/150",
                onKatil: () => _katil({'id': data.id}),
              );
            },
          );
        },
      ),

      // 🔹 ALT BAR
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                               ETKİNLİK KARTI                               */
/* -------------------------------------------------------------------------- */

class _EtkinlikKart extends StatelessWidget {
  final String baslik;
  final String tarih;
  final String aciklama;
  final VoidCallback onKatil;
  final String imageUrl;

  const _EtkinlikKart({
    required this.baslik,
    required this.tarih,
    required this.aciklama,
    required this.onKatil,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            baslik,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            tarih,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 10),
          Text(
            aciklama,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EtkinlikDetayPage(
                          baslik: baslik,
                          tarih: tarih,
                          aciklama: aciklama,
                          imageUrl: imageUrl,
                        ),
                      ),
                    );
                  },
                  child: const Text('Detaylar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onKatil,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 179, 166, 200),
                  ),
                  child: const Text('Katıl'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class EtkinlikDetayPage extends StatelessWidget {
  final String baslik;
  final String tarih;
  final String aciklama;
  final String imageUrl;

  const EtkinlikDetayPage({
    super.key,
    required this.baslik,
    required this.tarih,
    required this.aciklama,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(baslik)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(imageUrl),
            ),
            const SizedBox(height: 20),
            Text(
              baslik,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(tarih, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Text(aciklama, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
