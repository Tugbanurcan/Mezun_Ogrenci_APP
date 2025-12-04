import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'notifications.dart';
import 'profile_view_screen.dart';
import 'home_page.dart';

class MulakatPage extends StatefulWidget {
  const MulakatPage({super.key});

  @override
  State<MulakatPage> createState() => _MulakatPageState();
}

class _MulakatPageState extends State<MulakatPage> {
  int _selectedIndex = 3;

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

    final maddeler = [
      {
        'icon': Icons.lightbulb_outline,
        'title': "Hazırlıklı Git",
        'desc': "Şirketi ve pozisyonu önceden mutlaka araştır.",
        'detail':
        "Şirketin vizyonu, kültürü, projeleri, ekip yapısı ve pozisyonun sorumlulukları hakkında bilgi edinmek "
            "karşındaki kişiye ciddi bir aday olduğun mesajını verir. "
            "Google News, LinkedIn, şirket web sitesi ve Glassdoor iyi kaynaklardır.",
        'isOpen': false,
      },
      {
        'icon': Icons.access_time,
        'title': "Zamanında Git",
        'desc': "Mülakata 10 dakika önce gitmelisin.",
        'detail':
        "En kötü izlenimlerden biri geç kalmaktır. Online mülakatlarda bağlantı, kamera ve mikrofonu "
            "en az 10 dakika önce test etmelisin. Bağlantı problemleri ilk izlenimi olumsuz etkiler.",
        'isOpen': false,
      },
      {
        'icon': Icons.checkroom,
        'title': "Uygun Giyin",
        'desc': "Sade ve profesyonel bir görünüm tercih edilmelidir.",
        'detail':
        "Mülakat bir değerlendirme alanıdır. Kıyafetin profesyonel, temiz ve düzenli olmalıdır. "
            "Şirket kültürüne göre çok resmi veya çok günlük giyimden kaçın.",
        'isOpen': false,
      },
      {
        'icon': Icons.record_voice_over,
        'title': "Beden Dilini Doğru Kullan",
        'desc': "Göz teması, dik duruş ve kontrollü el hareketleri önemli.",
        'detail':
        "İletişimin %60’tan fazlası beden diliyle olur. Göz teması kurmak, dik oturmak, "
            "gereksiz el hareketlerinden kaçınmak profesyonellik izlenimi verir.",
        'isOpen': false,
      },
      {
        'icon': Icons.person_pin,
        'title': "Kendini Etkili Tanıt",
        'desc': "1 dakikalık güçlü bir açılış yap.",
        'detail':
        "Mülakatın başında kendini tanıtırken eğitim, deneyim ve güçlü yanlarını kısa ve net bir şekilde sunmalısın. "
            "Bu bölümü önceden prova etmen faydalı olur.",
        'isOpen': false,
      },
      {
        'icon': Icons.question_answer,
        'title': "Sorulara Net Yanıt Ver",
        'desc': "Bilmiyorsan dürüst ol, özgüvenli konuş.",
        'detail':
        "Bilmediğin bir soru gelirse panik yapma. 'Bu konuda tecrübem yok ama öğrenmeye açığım' gibi profesyonel "
            "cevaplar olumlu etki bırakır.",
        'isOpen': false,
      },
      {
        'icon': Icons.group_work,
        'title': "Somut Örnekler Ver",
        'desc': "Yeteneklerini örneklerle destekle.",
        'detail':
        "Takım çalışması, problem çözme, iletişim gibi soyut beceriler somut örneklerle desteklenmelidir. "
            "Mesela '4 kişilik ekiple X projesini tamamladık' gibi.",
        'isOpen': false,
      },
      {
        'icon': Icons.remove_red_eye_outlined,
        'title': "Gereksiz Detaylardan Kaçın",
        'desc': "Konuyu dağıtma, öz bir şekilde konuş.",
        'detail':
        "Gereksiz ayrıntılara girmek, çok uzun konuşmak veya konu dışına çıkmak profesyonel görünmez. "
            "Her cevabın net ve odaklı olmalı.",
        'isOpen': false,
      },
      {
        'icon': Icons.help_center,
        'title': "Sen de Soru Sor",
        'desc': "Pozisyona ilgi duyduğunu göster.",
        'detail':
        "Mülakatta soru sormak çok olumlu etki yaratır. Örneğin: 'Bu pozisyonda başarı nasıl ölçülüyor?' "
            "veya 'Ekip büyüklüğü nedir?' gibi.",
        'isOpen': false,
      },
      {
        'icon': Icons.mail_outline,
        'title': "Teşekkür Et ve Takipte Kal",
        'desc': "Görüşme sonrası e-posta büyük fark yaratır.",
        'detail':
        "Mülakat bittikten sonra kısa bir teşekkür maili göndermek profesyonellik göstergesidir. "
            "Adayların %80’i yapmadığı için seni öne geçirir.",
        'isOpen': false,
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,

      // ⭐ APPBAR
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
        centerTitle: true,
        title: const Text(
          "Mülakat Rehberi",
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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

      // ⭐ BODY (Kartlar)
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                      // ÜST BÖLÜM
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

                      // DETAY BUTONU
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

                      // AÇILAN / KAPANAN DETAY KUTUSU
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