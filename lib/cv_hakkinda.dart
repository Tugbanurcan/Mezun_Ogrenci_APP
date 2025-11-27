import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'notifications.dart';
import 'profile_view_screen.dart';
import 'home_page.dart';

class CvHakkindaPage extends StatefulWidget {
  const CvHakkindaPage({super.key});

  @override
  State<CvHakkindaPage> createState() => _CvHakkindaPageState();
}

class _CvHakkindaPageState extends State<CvHakkindaPage> {
  int _selectedIndex = 4;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const AnaSayfa()));
    }
  }

  @override
  Widget build(BuildContext context) {
    const anaRenk = Color(0xFF7AD0B0);

    final maddeler = [
      {
        'icon': Icons.edit_note,
        'title': "Öz ve net ol",
        'desc':
            "Uzun cümlelerden kaçın. CV kısa, anlaşılır ve profesyonel görünmeli."
      },
      {
        'icon': Icons.spellcheck,
        'title': "İmla hatası olmasın",
        'desc':
            "Bir yazım hatası bile CV’nin ciddiyetini azaltır. Göndermeden önce mutlaka kontrol et."
      },
      {
        'icon': Icons.update,
        'title': "Bilgiler güncel olmalı",
        'desc': "Telefon, e-posta, eğitim ve iş tecrübeleri güncel tutulmalı."
      },
      {
        'icon': Icons.timeline,
        'title': "Ters kronolojik sıra",
        'desc':
            "En güncel deneyim ve eğitimler en üstte yer almalı. İş veren önce yenilikleri görmek ister."
      },
      {
        'icon': Icons.design_services,
        'title': "Düzenli & sade görünüm",
        'desc':
            "Gereksiz renklerden kaçın. Okunabilir font kullan. Tasarım gözü yormamalı."
      },
      {
        'icon': Icons.verified_user,
        'title': "Gerçek bilgiler",
        'desc':
            "Abartılmış veya doğrulanamayan bilgiler seni zor durumda bırakabilir."
      },
      {
        'icon': Icons.tune,
        'title': "Pozisyona göre özelleştir",
        'desc':
            "Her iş başvurusu için ufak değişiklikler yap. İş veren bunu fark eder."
      },
      {
        'icon': Icons.highlight_off,
        'title': "Gereksiz bilgilerden kaçın",
        'desc':
            "TC kimlik, medeni hal, doğum tarihi gibi bilgiler artık CV’de kullanılmıyor."
      },
      {
        'icon': Icons.image,
        'title': "Fotoğraf gerekli ise ekle",
        'desc':
            "Profesyonel bir fotoğraf seç. Selfie veya filtreli fotoğraflardan kaçın."
      },
      {
        'icon': Icons.star_rate,
        'title': "Başarı odaklı yaz",
        'desc':
            "Sadece 'yaptım' deme – hangi başarıyı elde ettiğini de açıkla. İşte fark yaratan bu olur."
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 110,
        leading: Row(
          children: [
            IconButton(
              icon:
                  const Icon(Icons.arrow_back, color: Colors.black87, size: 26),
              onPressed: () {
                Navigator.pushReplacement(
                    context, MaterialPageRoute(builder: (_) => const AnaSayfa()));
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle,
                  color: Colors.black87, size: 28),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ProfileViewScreen()));
              },
            ),
          ],
        ),
        title: const Text(
          "CV Hazırlama Rehberi",
          style: TextStyle(
            fontSize: 20,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded,
                color: Colors.black54),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationPage()));
            },
          ),
        ],
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: anaRenk.withOpacity(0.2),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const Icon(Icons.description_outlined,
                      size: 50, color: anaRenk),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      "Profesyonel bir CV hazırlamak iş görüşmesine giden yolun ilk adımıdır.",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                        fontSize: 15,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Dikkat Edilmesi Gerekenler",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 12),

            // List of cards
            Column(
              children: maddeler.map((m) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: anaRenk.withOpacity(.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(m['icon'] as IconData,
                            color: anaRenk, size: 22),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m['title']!,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              m['desc']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),

      // BOTTOM NAV BAR
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
              onTap: () => _onItemTapped(0),
            ),
            AltIcon(
              ikon: Icons.event,
              label: 'Etkinlikler',
              isSelected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            AltIcon(
              ikon: Icons.home,
              label: 'Ana Sayfa',
              isSelected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            AltIcon(
              ikon: Icons.person_search,
              label: 'Mentor Bul',
              isSelected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            AltIcon(
              ikon: Icons.work_outline,
              label: 'İş & Staj',
              isSelected: _selectedIndex == 4,
              onTap: () => _onItemTapped(4),
            ),
          ],
        ),
      ),
    );
  }
}
