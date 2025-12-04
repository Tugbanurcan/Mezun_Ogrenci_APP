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
    }
    else if (index == 4) {
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
        leadingWidth: 60,
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.black87, size: 28),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
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
                  MaterialPageRoute(builder: (_) => const NotificationPage()),
                );
              },
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.black54,
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
            // ⭐ BAŞLIK
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
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
                      const Icon(Icons.groups_rounded,
                          color: Color(0xFF7AD0B0), size: 24),
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

            // 🔸 PROFİL KARTLARI
            SizedBox(
              height: 180,
              child: PageView.builder(
                itemCount: profiller.length,
                controller: PageController(viewportFraction: 0.88),
                itemBuilder: (context, index) {
                  final profil = profiller[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                              const SizedBox(height: 6),

                              // ⭐ Yıldızlar
                              const Row(
                                children: [
                                  Icon(Icons.star, color: Colors.amber, size: 20),
                                  Icon(Icons.star_border, color: Colors.grey, size: 20),
                                  Icon(Icons.star_border, color: Colors.grey, size: 20),
                                  Icon(Icons.star_border, color: Colors.grey, size: 20),
                                  Icon(Icons.star_border, color: Colors.grey, size: 20),
                                ],
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

            // Etkinlik kartı
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
                  children: const [
                    _EtkinlikSatiri(),
                    SizedBox(height: 8),
                    _EtkinlikSatiri(),
                    SizedBox(height: 8),
                    _EtkinlikSatiri(),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            // 🔸 KARE BUTONLAR (Modern, Renkli, Responsive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _KareButon(
                      ikon: Icons.work_outline,
                      label: "CV",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CvHakkindaPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _KareButon(
                      ikon: Icons.description_outlined,
                      label: "FORUM",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CommunityPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _KareButon(
                      ikon: Icons.people_outline,
                      label: "MÜLAKAT",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const MulakatPage()),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: _KareButon(
                      ikon: Icons.school,
                      label: "AKADEMİSYENLER",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const BolumHakkindaPage()),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
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

class _EtkinlikSatiri extends StatelessWidget {
  const _EtkinlikSatiri({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Expanded(
          child: Text(
            '10 Mart: Atölye – “Sektörlere Giriş”',
            style: TextStyle(fontSize: 14, color: Colors.black87),
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
    );
  }
}

// 🔥 MODERN KARE BUTON SINIFI
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

      case "AKADEMİSYENLER":
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
            height: 90,
            decoration: BoxDecoration(
              color: _getColor(label),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                ikon,
                size: 34,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
