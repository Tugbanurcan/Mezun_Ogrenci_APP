import 'package:flutter/material.dart';
import 'home_page.dart';
import 'mentor_bul_page.dart';
import 'is_staj_page.dart';
import 'widgets/bottom_nav_bar.dart';
import 'chat_page.dart';
import 'home_page.dart';

class EtkinliklerPage extends StatefulWidget {
  const EtkinliklerPage({super.key});

  @override
  State<EtkinliklerPage> createState() => _EtkinliklerPageState();
}

class _EtkinliklerPageState extends State<EtkinliklerPage> {
  // Navigasyonda Etkinlikler indexi
  final int _currentIndex = 1;

  // 🔥 KATILDIĞIM ETKİNLİKLER
  final List<Map<String, String>> _katildiklarim = [];

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
  void _katil(Map<String, String> etkinlik) {
    if (_katildiklarim.contains(etkinlik)) return;

    setState(() {
      _katildiklarim.add(etkinlik);
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Etkinliğe katıldınız 🎉')));
  }

  // 🔹 Katıldıklarım Modal
  void _showKatildiklarim() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        if (_katildiklarim.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Henüz katıldığınız bir etkinlik yok.',
                style: TextStyle(fontSize: 15),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _katildiklarim.length,
          itemBuilder: (context, index) {
            final etkinlik = _katildiklarim[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                title: Text(etkinlik['baslik']!),
                subtitle: Text(etkinlik['tarih']!),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    setState(() {
                      _katildiklarim.removeAt(index);
                    });
                    Navigator.pop(context);
                  },
                ),
              ),
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
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _etkinlikler.length,
        itemBuilder: (context, index) {
          final etkinlik = _etkinlikler[index];
          return _EtkinlikKart(
            baslik: etkinlik['baslik']!,
            tarih: etkinlik['tarih']!,
            aciklama: etkinlik['aciklama']!,
            onKatil: () => _katil(etkinlik),
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

  const _EtkinlikKart({
    required this.baslik,
    required this.tarih,
    required this.aciklama,
    required this.onKatil,
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
                  onPressed: () {},
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

/* -------------------------------------------------------------------------- */
/*                               DUMMY DATA                                   */
/* -------------------------------------------------------------------------- */

final List<Map<String, String>> _etkinlikler = [
  {
    'baslik': 'Flutter ile Mobil Uygulama Geliştirme',
    'tarih': '20 Mart 2026',
    'aciklama':
        'Flutter kullanarak modern ve performanslı mobil uygulamalar geliştirme.',
  },
  {
    'baslik': 'Yapay Zeka ve Makine Öğrenmesi',
    'tarih': '28 Mart 2026',
    'aciklama': 'Makine öğrenmesi algoritmaları ve gerçek hayat uygulamaları.',
  },
  {
    'baslik': 'Kariyer Planlama & CV Hazırlama',
    'tarih': '5 Nisan 2026',
    'aciklama': 'Yeni mezunlar için CV hazırlama ve mülakat teknikleri.',
  },
];
