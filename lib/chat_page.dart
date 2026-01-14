import 'package:flutter/material.dart';
import 'chat_detail_page.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _searchController = TextEditingController();

  // 🔹 Kullanıcı listesi (State içinde → silme için gerekli)
  final List<Map<String, String>> _kullanicilar = [
    {'isim': 'Selenay Demirpençe', 'sonMesaj': 'Merhaba 👋'},
    {'isim': 'Ahmet Yılmaz', 'sonMesaj': 'Toplantı ne zaman?'},
    {'isim': 'Elif Kaya', 'sonMesaj': 'Projeye baktım 👍'},
    {'isim': 'Mehmet Demir', 'sonMesaj': 'CV’yi gönderebilir misin?'},
  ];

  String _arama = '';

  @override
  Widget build(BuildContext context) {
    // 🔍 Arama filtresi
    final filtreliListe = _kullanicilar.where((kisi) {
      final q = _arama.toLowerCase();
      if (q.isEmpty) return true;

      return kisi['isim']!.toLowerCase().contains(q) ||
          kisi['sonMesaj']!.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      // 🔹 APPBAR
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Sohbetler',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
      ),

      body: Column(
        children: [
          // 🔍 ARAMA KUTUSU
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _arama = v),
              decoration: InputDecoration(
                hintText: 'Kişi veya mesaj ara...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🔹 CHAT LİSTESİ
          Expanded(
            child: ListView.separated(
              itemCount: filtreliListe.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final kisi = filtreliListe[index];

                return GestureDetector(
                  onLongPress: () {
                    _showDeleteDialog(context, kisi);
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.deepPurple.shade200,
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      kisi['isim']!,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      kisi['sonMesaj']!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailPage(isim: kisi['isim']!),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🗑️ SİLME DİYALOĞU
  void _showDeleteDialog(BuildContext context, Map<String, String> kisi) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Sohbeti Sil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text('${kisi['isim']} ile olan sohbet silinsin mi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              setState(() {
                _kullanicilar.remove(kisi);
              });
              Navigator.pop(context);
            },
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }
}
