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
              // 🌟 Yeni Başlık Tasarımı
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF47A397), Color(0xFF7AD0B0)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
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
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            padding: const EdgeInsets.all(6),
                            child: const Icon(
                              Icons.groups_rounded,
                              color: Colors.white,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Mentörlerimiz',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 3,
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF47A397), Color(0xFF7AD0B0)],
                        ),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              //Mentör Listesi Kartı
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users') // Koleksiyon adın 'users'
                    .where(
                      'isMentor',
                      isEqualTo: true,
                    ) // SADECE MENTÖRLERİ GETİR
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                      height: 230,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const SizedBox(
                      height: 230,
                      child: Center(
                        child: Text("Henüz sistemde mentör bulunmuyor."),
                      ),
                    );
                  }

                  final mentorDocs = snapshot.data!.docs;

                  return SizedBox(
                    height: 230,
                    child: PageView.builder(
                      itemCount: mentorDocs.length,
                      controller: PageController(viewportFraction: 0.9),
                      itemBuilder: (context, index) {
                        final data =
                            mentorDocs[index].data() as Map<String, dynamic>;
                        final String uid = mentorDocs[index].id;

                        final String isim = data['name'] ?? 'İsimsiz';
                        final String unvan =
                            data['title'] ?? (data['userType'] ?? 'Mezun');
                        final String photoUrl = data['photoPath'] ?? "";

                        return GestureDetector(
                          onTap: () {
                            // CHAT YERİNE PROFİLE GİT
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProfileViewScreen(mentorUid: uid),
                                // Not: ProfileViewScreen'e dışarıdan bir UID göndererek
                                // o kişinin verilerini çekmesini sağlayabilirsin.
                              ),
                            );
                          },
                          child: Container(
                            // ... (Mevcut dekorasyon ve padding kodların buraya gelecek)
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF7AD0B0,
                                  ).withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                              child: Row(
                                children: [
                                  // Profil Resmi Bölümü
                                  Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          Color(0xFF7AD0B0),
                                          Color(0xFF47A397),
                                        ],
                                      ),
                                    ),
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.white,
                                      child: CircleAvatar(
                                        radius: 37,
                                        backgroundColor: Colors.grey.shade100,
                                        backgroundImage:
                                            (photoUrl.isNotEmpty &&
                                                photoUrl != "null")
                                            ? NetworkImage(photoUrl)
                                            : null,
                                        child:
                                            (photoUrl.isEmpty ||
                                                photoUrl == "null")
                                            ? const Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                                size: 38,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Bilgiler Bölümü
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isim,
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 3,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(
                                              0xFF7AD0B0,
                                            ).withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Text(
                                            unvan,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF47A397),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // Yıldızlar
                                        Row(
                                          children: List.generate(
                                            5,
                                            (i) => const Icon(
                                              Icons.star_rounded,
                                              color: Colors.amber,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Color(0xFF7AD0B0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ); // return GestureDetector sonu
                      },
                    ),
                  );
                },
              ),

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
              // 🔸 KARE BUTONLAR Kısmı
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ), // Padding'i biraz azalttık
                child: Row(
                  children: [
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.work_outline,
                        label: "CV",
                        bgColor: Colors.orange.withOpacity(0.1), // Renk eklendi
                        iconColor: Colors.orange, // Renk eklendi
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CvHakkindaPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.description_outlined,
                        label: "FORUM",
                        bgColor: Colors.blue.withOpacity(0.1), // Renk eklendi
                        iconColor: Colors.blue, // Renk eklendi
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CommunityPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.people_outline,
                        label: "MÜLAKAT",
                        bgColor: Colors.purple.withOpacity(0.1), // Renk eklendi
                        iconColor: Colors.purple, // Renk eklendi
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MulakatPage(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _KareButon(
                        ikon: Icons.school,
                        label: "AKADEMİ",
                        bgColor: Colors.green.withOpacity(0.1), // Renk eklendi
                        iconColor: Colors.green, // Renk eklendi
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
              imageUrl: data['imageUrl'] ?? "https://picsum.photos/200/300",
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
  final Color bgColor; // Renk parametreleri
  final Color iconColor;
  final VoidCallback? onTap;

  const _KareButon({
    required this.ikon,
    required this.label,
    required this.bgColor,
    required this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Burada en dıştaki Expanded'ı sildik!
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // Genişliği otomatik ayarlasın diye kısıtlama koymuyoruz
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45, // Boyutu biraz küçülttük ki 4 tanesi yanyana sığsın
              height: 45,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(ikon, size: 22, color: iconColor),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10, // Fontu 10 yaptık taşma olmasın
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
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
