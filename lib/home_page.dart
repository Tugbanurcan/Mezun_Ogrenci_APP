import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'profile_view_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'notifications.dart';
import 'bolum_hakkinda.dart';
import 'cv_hakkinda.dart';
import 'mulakat_page.dart';
import 'community_page.dart';
import 'mentor_bul_page.dart';
import 'is_staj_page.dart';
import 'etkinlikler_page.dart';
import 'chat_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_detail_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ChatPage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const EtkinliklerPage()),
      );
    } else if (index == 2) {
      // Zaten Ana Sayfadayız
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
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> profiller = [
      {
        'uid': 'UID_1',
        'isim': 'Selenay Demirpençe',
        'unvan': 'Computer Engineer',
        'aciklama': 'AI • Flutter • ML Enthusiast',
      },
      {
        'uid': 'UID_2',
        'isim': 'Ahmet Yılmaz',
        'unvan': 'Software Developer',
        'aciklama': 'Mobile Apps | Firebase | Backend',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 60,
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle,
            color: Colors.black87,
            size: 28,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
            );
          },
        ),
        actions: [
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('notifications')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('items')
                .where('isRead', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              final bool hasNotifications =
                  snapshot.hasData && snapshot.data!.docs.isNotEmpty;

              return Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const NotificationPage(),
                      ),
                    );
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        hasNotifications
                            ? Icons.notifications_active_rounded
                            : Icons.notifications_none_rounded,
                        color: hasNotifications
                            ? const Color.fromARGB(255, 0, 0, 0)
                            : Colors.black54,
                        size: 26,
                      ),
                      if (hasNotifications)
                        Positioned(
                          top: 12,
                          right: 0,
                          child: Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ⭐ BAŞLIK
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 6,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 6,
                          height: 26,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7AD0B0),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Icon(
                          Icons.groups_rounded,
                          color: Color(0xFF7AD0B0),
                          size: 24,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Mentörlerimiz',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 120,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7AD0B0), Color(0xFF47A397)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // 🔸 PROFİL KARTLARI (PageView)
              SizedBox(
                height: 180,
                child: PageView.builder(
                  itemCount: profiller.length,
                  controller: PageController(viewportFraction: 0.88),
                  itemBuilder: (context, index) {
                    final profil = profiller[index];

                    return GestureDetector(
                      onTap: () async {
                        String otherUserId = profil['uid']!;
                        String chatId = await createOrGetChat(otherUserId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatDetailPage(
                              chatId: chatId,
                              isim: profil['isim'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 10,
                        ),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 35,
                              backgroundColor: Color(0xFFE0E0E0),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    profil['isim'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    profil['unvan'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    profil['aciklama'] ?? '',
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (i) => Icon(
                                        i == 0 ? Icons.star : Icons.star_border,
                                        color: i == 0
                                            ? Colors.amber
                                            : Colors.grey,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              // ⭐ ETKİNLİK BAŞLIĞI
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Text(
                  'Yaklaşan Etkinlikler',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('etkinlikler') // Firestore'daki koleksiyon adın
                    .orderBy('tarih', descending: false)
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text("Yakın zamanda etkinlik bulunmuyor."),
                    );
                  }

                  // İŞTE SORDUĞUN KISIM BURASI:
                  final eventDocs = snapshot.data!.docs;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: eventDocs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return ModernEtkinlikKarti(
                          data: data,
                        ); // Daha önce yazdığımız şık kart
                      }).toList(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 30),

              // 🔸 KARE BUTONLAR
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.work_outline,
                        label: "CV",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CvHakkindaPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.description_outlined,
                        label: "FORUM",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CommunityPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.people_outline,
                        label: "MÜLAKAT",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MulakatPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.school,
                        label: "AKADEMİ",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const BolumHakkindaPage(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      // ALT MENÜ
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AltIcon(
              ikon: Icons.chat,
              label: 'Chat',
              isSelected: _selectedIndex == 0,
              onTap: () => _onclick(0),
            ),
            AltIcon(
              ikon: Icons.event,
              label: 'Etkinlikler',
              isSelected: _selectedIndex == 1,
              onTap: () => _onclick(1),
            ),
            AltIcon(
              ikon: Icons.home,
              label: 'Ana Sayfa',
              isSelected: _selectedIndex == 2,
              onTap: () => _onclick(2),
            ),
            AltIcon(
              ikon: Icons.person_search,
              label: 'Mentor Bul',
              isSelected: _selectedIndex == 3,
              onTap: () => _onclick(3),
            ),
            AltIcon(
              ikon: Icons.work_outline,
              label: 'İş & Staj',
              isSelected: _selectedIndex == 4,
              onTap: () => _onclick(4),
            ),
          ],
        ),
      ),
    );
  }

  void _onclick(int index) => _onItemTapped(index);
}

class ModernEtkinlikKarti extends StatelessWidget {
  final Map<String, dynamic> data;
  const ModernEtkinlikKarti({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final Timestamp? ts = data['tarih'] as Timestamp?;
    final DateTime date = ts?.toDate() ?? DateTime.now();

    // Formatlanmış tarih (Detay sayfasına göndermek için)
    final String formattedDate = "${date.day}/${date.month}/${date.year}";

    return GestureDetector(
      onTap: () {
        // Tıklanınca detay sayfasına yönlendir
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EtkinlikDetayPage(
              baslik: data['baslik'] ?? 'Etkinlik',
              tarih: formattedDate,
              aciklama: data['aciklama'] ?? '',
              imageUrl: data['imageUrl'] ?? "https://via.placeholder.com/150",
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Takvim kutusu
            Container(
              width: 50,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF7AD0B0).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${date.day}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF47A397),
                    ),
                  ),
                  Text(
                    _getMonthName(date.month),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF47A397),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Yazılar
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['baslik'] ?? 'Etkinlik',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Detayları görmek için tıkla",
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Oca",
      "Şub",
      "Mar",
      "Nis",
      "May",
      "Haz",
      "Tem",
      "Ağu",
      "Eyl",
      "Eki",
      "Kas",
      "Ara",
    ];
    return months[month - 1];
  }
}

class _KareButon extends StatelessWidget {
  final IconData ikon;
  final String label;
  final VoidCallback? onTap;

  const _KareButon({
    required this.ikon,
    required this.label,
    this.onTap,
    super.key,
  });

  Color _getColor(String label) {
    switch (label) {
      case "CV":
        return const Color(0xFFE3F2FD);
      case "FORUM":
        return const Color(0xFFFFF3E0);
      case "MÜLAKAT":
        return const Color(0xFFE8F5E9);
      case "AKADEMİ":
        return const Color(0xFFF3E5F5);
      default:
        return const Color(0xFFE0E0E0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 80, // Mobilde daha iyi sığması için biraz küçültüldü
            decoration: BoxDecoration(
              color: _getColor(label),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(child: Icon(ikon, size: 30, color: Colors.black87)),
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> createOrGetChat(String otherUserId) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return "";
  final currentUser = user.uid;

  final query = await FirebaseFirestore.instance
      .collection('chats')
      .where('participants', arrayContains: currentUser)
      .get();

  for (var doc in query.docs) {
    List users = doc['participants'];
    if (users.contains(otherUserId)) {
      return doc.id;
    }
  }

  final newChat = await FirebaseFirestore.instance.collection('chats').add({
    'participants': [currentUser, otherUserId],
    'lastMessage': '',
    'timestamp': FieldValue.serverTimestamp(),
  });

  return newChat.id;
}
