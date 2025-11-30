import 'package:flutter/material.dart';
import 'home_page.dart';
import 'widgets/alt_icon.dart';
import 'is_staj_page.dart';
import 'mentor_profil.dart';

class MentorBulPage extends StatefulWidget {
  const MentorBulPage({super.key});

  @override
  State<MentorBulPage> createState() => _MentorBulPageState();
}

class _MentorBulPageState extends State<MentorBulPage> {
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _tumMentorler = [
    {
      'isim': 'Selenay Demirpençe',
      'unvan': 'Backend Developer',
      'sirket': 'TrendTech',
      'yil': '2020',
      'aciklama': 'Java • Spring • Microservices',
      'mail': 'selenay@trendtech.com',
    },
    {
      'isim': 'Ahmet Yılmaz',
      'unvan': 'iOS Developer',
      'sirket': 'MobilityX',
      'yil': '2019',
      'aciklama': 'Swift • UIKit • Firebase',
      'mail': 'ahmet@trendtech.com',
    },
    {
      'isim': 'Elif Kaya',
      'unvan': 'Data Scientist',
      'sirket': 'InsightLab',
      'yil': '2018',
      'aciklama': 'Python • NLP • Deep Learning',
      'mail': 'elif@trendtech.com',
    },
    {
      'isim': 'Mehmet Demir',
      'unvan': 'Frontend Developer',
      'sirket': 'PixelSoft',
      'yil': '2021',
      'aciklama': 'React • TypeScript • UI/UX',
      'mail': 'mehmet@trendtech.com',
    },
    {
      'isim': 'Zeynep Öz',
      'unvan': 'Cloud Engineer',
      'sirket': 'Cloudify',
      'yil': '2017',
      'aciklama': 'AWS • DevOps • Docker',
      'mail': 'zeynep@trendtech.com',
    },
    {
      'isim': 'Kerem Çelik',
      'unvan': 'Product Manager',
      'sirket': 'NextMove',
      'yil': '2016',
      'aciklama': 'Roadmap • UX • Agile',
      'mail': 'kerem@trendtech.com',
    },
  ];

  String _arama = '';

  @override
  Widget build(BuildContext context) {
    // 📌 Responsive grid ayarı için gerekebilir (şu an kullanılmıyor ama dursun)
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // 📌 Arama filtresi
    final filtreliListe = _tumMentorler.where((m) {
      final q = _arama.toLowerCase();
      if (q.isEmpty) return true;

      return m['isim']!.toLowerCase().contains(q) ||
          m['unvan']!.toLowerCase().contains(q) ||
          m['sirket']!.toLowerCase().contains(q);
    }).toList();

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
              child: GridView.builder(
                itemCount: filtreliListe.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68, // ⭐ OVERFLOW ÇÖZÜLDÜ
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return _MentorKart(mentor: filtreliListe[index]);
                },
              ),
            ),
          ],
        ),
      ),

      // ⭐ ALT BAR
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
              isSelected: false, // hiçbir ikon mavi olmayacak
              onTap: () {
                // Chat sayfan yok, yapılınca buraya yönlendirme eklersin
              },
            ),
            AltIcon(
              ikon: Icons.event,
              label: 'Etkinlikler',
              isSelected: false,
              onTap: () {
                // Etkinlikler sayfan yok, yapılınca ekle
              },
            ),
            AltIcon(
              ikon: Icons.home,
              label: 'Ana Sayfa',
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AnaSayfa()),
                );
              },
            ),
            AltIcon(
              ikon: Icons.person_search,
              label: 'Mentor Bul',
              isSelected: true,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MentorBulPage()),
                );
              },
            ),
            AltIcon(
              ikon: Icons.work_outline,
              label: 'İş & Staj',
              isSelected: false,
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const IsStajPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------- MENTOR KARTI --------------------

class _MentorKart extends StatelessWidget {
  final Map<String, String> mentor;

  const _MentorKart({required this.mentor});

  @override
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
            mentor['isim']!,
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
            mentor['aciklama']!,
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
                      isim: mentor['isim']!,
                      unvan: mentor['unvan']!,
                      sirket: mentor['sirket']!,
                      yil: mentor['yil']!,
                      aciklama: mentor['aciklama']!,
                      fotoUrl: "", // İstersen ekleyebilirsin
                      linkedin: "",
                      github: "",
                      hakkinda: mentor['aciklama']!, // şimdilik aynı dursun
                      yetkinlikler: [], // İstersen doldururuz
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: const Text(
                'Mentorluk Talebi Gönder',
                style: TextStyle(fontSize: 11),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
