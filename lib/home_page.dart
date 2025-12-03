import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Yeni widget'ı import ediyoruz
import 'widgets/bottom_nav_bar.dart';

import 'profile_view_screen.dart';
import 'notifications.dart';
import 'bolum_hakkinda.dart';
import 'cv_hakkinda.dart';
import 'mulakat_page.dart';
import 'community_page.dart';
import 'mentor_bul_page.dart';
import 'is_staj_page.dart'; // İş & Staj sayfasına yönlendirme için gerekli olabilir

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
  int _selectedIndex = 2; // Ana sayfa varsayılan olarak seçili

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Navigasyon Yönlendirmeleri
    if (index == 2) {
      // Ana Sayfa (Kendisi) - Yenileme gibi davranır
      // İstersen burada hiçbir şey yapmayabilirsin.
    } else if (index == 3) {
      // Mentor Bul Sayfası
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MentorBulPage()),
      );
    } else if (index == 4) {
      // İş & Staj Sayfası
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const IsStajPage()),
      );
    }
    // Chat (0) ve Etkinlikler (1) için henüz sayfa tanımlı değilse boş kalabilir.
  }

  @override
  Widget build(BuildContext context) {
    // Profil listesi (Örnek veri)
    final List<Map<String, String>> profiller = [
      {
        'isim': 'Selenay Demirpençe',
        'unvan': 'Computer Engineer',
        'aciklama': 'AI • Flutter • ML Enthusiast',
      },
      {
        'isim': 'Ahmet Yılmaz',
        'unvan': 'Software Developer',
        'aciklama': 'Mobile Apps | Firebase | Backend',
      },
      {
        'isim': 'Elif Kaya',
        'unvan': 'Data Scientist',
        'aciklama': 'Python • NLP • Deep Learning',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const SizedBox(),
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
              MaterialPageRoute(
                builder: (context) => const ProfileViewScreen(),
              ),
            );
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationPage(),
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔸 Profil kartları
            SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: profiller.length,
                controller: PageController(viewportFraction: 0.88),
                itemBuilder: (context, index) {
                  final profil = profiller[index];
                  return Container(
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
                                profil['isim']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profil['unvan']!,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                profil['aciklama']!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '10 Mart: Atölye – “Sektörlere Giriş”',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          'KATIL',
                          style: TextStyle(
                            color: Color(0xFF7AD0B0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '10 Mart: Atölye – “Sektörlere Giriş”',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          'KATIL',
                          style: TextStyle(
                            color: Color(0xFF7AD0B0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '15 Mart: CV Hazırlama Atölyesi',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        Text(
                          'KATIL',
                          style: TextStyle(
                            color: Color(0xFF7AD0B0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KareButon(
                    ikon: Icons.work_outline,
                    label: "CV",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CvHakkindaPage(),
                        ),
                      );
                    },
                  ),
                  _KareButon(
                    ikon: Icons.description_outlined,
                    label: "formlar",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CommunityPage(),
                        ),
                      );
                    },
                  ),
                  _KareButon(
                    ikon: Icons.people_outline,
                    label: "MÜLAKAT",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const MulakatPage()),
                      );
                    },
                  ),
                  _KareButon(
                    ikon: Icons.school,
                    label: "AKADEMİSYENLER",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BolumHakkindaPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(ikon, color: Colors.black26, size: 35),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
