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
    setState(() => _selectedIndex = index);

    if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    const anaRenk = Color(0xFF7AD0B0);

    // ⭐ Her maddeye detay ekleyelim ve isOpen koyuyoruz
    final maddeler = [
      {
        'icon': Icons.edit_note,
        'title': "Öz ve net ol",
        'desc':
            "Uzun cümlelerden kaçın. CV kısa, anlaşılır ve profesyonel görünmeli.",
        'detail':
            "İş verenler CV’yi ortalama 6–8 saniye inceler. Bu yüzden bilgilerin kısa, net ve direkt olmalıdır. "
            "Gereksiz uzun cümleler yerine güçlü yönlerini, başarılarını ve somut sonuçlarını yaz.",
        'isOpen': false,
      },
      {
        'icon': Icons.spellcheck,
        'title': "İmla hatası olmasın",
        'desc': "Küçük yazım hataları bile CV’nin ciddiyetini azaltır.",
        'detail':
            "CV’nin profesyonel görünmesi için yazım hatası olmamalıdır. Düzenleme yaptıktan sonra tekrar gözden geçir, "
            "mümkünse başka birine okut veya Grammarly gibi araçlar kullan.",
        'isOpen': false,
      },
      {
        'icon': Icons.update,
        'title': "Bilgiler güncel olmalı",
        'desc': "İletişim ve eğitim bilgilerini güncel tut.",
        'detail':
            "Telefon numaran, e-posta adresin, LinkedIn profilin ve portföy linkin mutlaka güncel olmalıdır. "
            "Ayrıca eski veya geçerliliğini yitirmiş bilgileri kaldırmalısın.",
        'isOpen': false,
      },
      {
        'icon': Icons.timeline,
        'title': "Ters kronolojik sıra",
        'desc': "En güncel deneyim en üstte.",
        'detail':
            "En güncel iş ve eğitim deneyimini ilk sıraya koymalısın. İş veren önce en güncel bilgiyi görmek ister.",
        'isOpen': false,
      },
      {
        'icon': Icons.design_services,
        'title': "Düzenli & sade görünüm",
        'desc': "Sade tasarım profesyonellik getirir.",
        'detail':
            "Karmaşık fontlar, çok renkli tasarımlar profesyonel görünmez. Modern ve sade bir tasarım tercih edin.",
        'isOpen': false,
      },
      {
        'icon': Icons.verified_user,
        'title': "Gerçek bilgiler",
        'desc': "Abartma, doğrulanabilir bilgiler ver.",
        'detail':
            "İş verenler referans kontrolü yapabilir. Bu yüzden çalışma süreleri ve görevler doğrulanabilir olmalıdır.",
        'isOpen': false,
      },
      {
        'icon': Icons.tune,
        'title': "Pozisyona göre özelleştir",
        'desc': "Aynı CV’yi her yere göndermek hata!",
        'detail':
            "Başvurduğun pozisyona göre CV’ni ufak dokunuşlarla özelleştir. İlanda yazan yetenekleri öne çıkar.",
        'isOpen': false,
      },
      {
        'icon': Icons.highlight_off,
        'title': "Gereksiz bilgilerden kaçın",
        'desc': "TC kimlik, medeni hal gibi bilgiler eklenmez.",
        'detail':
            "Modern CV’lerde özel hayat bilgileri (doğum tarihi, adres, medeni hal vb.) gereksiz ve kullanılmamaktadır.",
        'isOpen': false,
      },
      {
        'icon': Icons.image,
        'title': "Fotoğraf gerekli ise ekle",
        'desc': "Profesyonel, sade bir fotoğraf tercih et.",
        'detail':
            "Fotoğraf zorunlu değildir. Ekliyorsan profesyonel bir fotoğraf tercih et. Selfie ve filtre kesinlikle olmaz.",
        'isOpen': false,
      },
      {
        'icon': Icons.star_rate,
        'title': "Başarı odaklı yaz",
        'desc': "Sonuç ve katkılarını açıkla.",
        'detail':
            "Görev listesi yazmak yerine elde ettiğin başarıları vurgula. Örneğin: '%30 performans artışı sağladım'.",
        'isOpen': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 110,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const AnaSayfa()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.account_circle, color: Colors.black87),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileViewScreen()),
                );
              },
            ),
          ],
        ),
        title: const Text(
          "CV Hazırlama Rehberi",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: maddeler.asMap().entries.map((entry) {
            int index = entry.key;
            var m = entry.value;

            return StatefulBuilder(
              builder: (context, setStateCard) {
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: anaRenk.withOpacity(.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              m['icon'] as IconData,
                              color: anaRenk,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  m['title'] as String,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  m['desc'] as String,
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

                      const SizedBox(height: 12),

                      // ⭐ DETAY KUTUSU AÇ/KAPAT
                      TextButton(
                        onPressed: () {
                          setStateCard(() {
                            m['isOpen'] = !(m['isOpen'] as bool);
                          });
                        },
                        child: Text(
                          m['isOpen'] as bool ? "Kapat" : "Detay",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // ⭐ AÇILAN DETAY KUTUSU
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: (m['isOpen'] as bool)
                            ? Container(
                                key: ValueKey("detail_$index"),
                                padding: const EdgeInsets.all(14),
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  m['detail'] as String,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.grey.shade800,
                                    height: 1.5,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),

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
