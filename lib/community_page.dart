import 'package:flutter/material.dart';
import 'widgets/alt_icon.dart';
import 'home_page.dart';
import 'profile_view_screen.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}


// altbar fonksiyonu
class _CommunityPageState extends State<CommunityPage> {
  int _selectedIndex = -1; // Alt bardaki seçili ikon
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 2) { // Ana Sayfa ikonu
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AnaSayfa()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Topluluk forumları",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            // 1. ADIM: Tıklama özelliği için GestureDetector ekliyoruz
            child: GestureDetector(
              onTap: () {
                // 2. ADIM: Sayfa geçiş kodunu buraya yazıyoruz
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileViewScreen()),
                );
              },
              child: const CircleAvatar(
                radius: 15,
                backgroundColor: Colors.black,
                child: Icon(Icons.person, color: Colors.white, size: 20),
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          ForumKarti(
            etiket: "Staj",
            cevapSayisi: "3 Cevap",
            baslik: "Yaz stajı bulmak için ne yapmalıyım?",
            aciklama: "Staj başvuruları konusunda...",
            yazarBilgisi: "Ahmet Yılmaz . 2 gün önce",
          ),
          SizedBox(height: 15),
          ForumKarti(
            etiket: "Ders",
            cevapSayisi: "5 Cevap",
            baslik: "Veri Yapıları dersi için kaynak önerisi...",
            aciklama: "Çalışma için etkili kaynaklar arıyorum...",
            yazarBilgisi: "Zeynep Demir . 2 gün önce",
          ),
        ],
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
        )
    );
  }
}

// kart yapısııı

class CustomButton extends StatelessWidget {
  final String text;

  const CustomButton({
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ... (Önceki importlar ve CommunityPage kodu aynen kalacak) ...

// --- ForumKarti KODUNU BUNUNLA DEĞİŞTİR ---





class ForumKarti extends StatefulWidget {
  final String etiket;
  final String cevapSayisi;
  final String baslik;
  final String aciklama;
  final String yazarBilgisi;

  const ForumKarti({
    required this.etiket,
    required this.cevapSayisi,
    required this.baslik,
    required this.aciklama,
    required this.yazarBilgisi,
    super.key,
  });

  @override
  State<ForumKarti> createState() => _ForumKartiState();
}

class _ForumKartiState extends State<ForumKarti> {
  bool _isExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  // -1: Yeni Ana Yorum, 0,1,2...: Hangi indexli ana yoruma cevap veriyoruz?
  int _replyingToIndex = -1;

  // DÜZENLEME HEDEFİ: [AnaYorumIndex, AltYorumIndex].
  // AltYorumIndex -1 ise Ana yorumu düzenliyoruz demektir.
  List<int>? _editingTarget;

  // VERİ YAPISI
  final List<Map<String, dynamic>> _yorumlar = [
    {
      "ad": "Mehmet Y.",
      "text": "Kesinlikle katılıyorum, bence Coursera üzerindeki eğitimlere de bakmalısın.",
      "isMe": false,
      "tarih": "04.12.2025 14:20",
      "avatarColor": Colors.orange,
      "altYorumlar": [
        {
          "ad": "Sen",
          "text": "Teşekkürler hocam, listeme ekledim.",
          "isMe": true,
          "tarih": "04.12.2025 14:35",
          "avatarColor": Colors.blue,
        }
      ]
    },
    {
      "ad": "Ayşe K.",
      "text": "YouTube'da FreeCodeCamp kanalı veri yapıları için harika.",
      "isMe": false,
      "tarih": "03.12.2025 09:00",
      "avatarColor": Colors.purple,
      "altYorumlar": []
    },
    {
      "ad": "Sen",
      "text": "Udemy'deki kurslar hakkında ne düşünüyorsunuz?",
      "isMe": true,
      "tarih": "04.12.2025 12:00",
      "avatarColor": Colors.blue,
      "altYorumlar": []
    },
  ];

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _cancelAction();
    });
  }

  // İşlemleri sıfırla (Vazgeç)
  void _cancelAction() {
    setState(() {
      _replyingToIndex = -1;
      _editingTarget = null; // Edit modundan çık
      _commentController.clear();
      FocusScope.of(context).unfocus();
    });
  }

  // --- SİLME FONKSİYONU ---
  void _deleteComment(int mainIndex, int subIndex) {
    setState(() {
      if (subIndex == -1) {
        // Ana yorumu sil (altındakilerle birlikte gider)
        _yorumlar.removeAt(mainIndex);
      } else {
        // Alt yorumu sil
        _yorumlar[mainIndex]['altYorumlar'].removeAt(subIndex);
      }

      // Eğer o an düzenlediğimiz şeyi sildiysek edit modunu kapat
      if (_editingTarget != null && _editingTarget![0] == mainIndex) {
        _cancelAction();
      }
    });
  }

  // --- DÜZENLEMEYİ BAŞLAT ---
  void _startEdit(int mainIndex, int subIndex, String currentText) {
    setState(() {
      _editingTarget = [mainIndex, subIndex];
      _replyingToIndex = -1; // Cevaplamayı iptal et
      _commentController.text = currentText; // Eski metni kutuya koy
    });
    // Klavyeyi aç
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // --- GÖNDER / KAYDET BUTONU ---
  void _handleSubmit() {
    if (_commentController.text.trim().isEmpty) return;

    String simdi = "${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}";

    setState(() {
      // 1. DURUM: DÜZENLEME (EDIT)
      if (_editingTarget != null) {
        int mIdx = _editingTarget![0];
        int sIdx = _editingTarget![1];

        if (sIdx == -1) {
          // Ana yorumu güncelle
          _yorumlar[mIdx]['text'] = _commentController.text;
        } else {
          // Alt yorumu güncelle
          _yorumlar[mIdx]['altYorumlar'][sIdx]['text'] = _commentController.text;
        }
      }
      // 2. DURUM: YANIT VERME (REPLY)
      else if (_replyingToIndex != -1) {
        _yorumlar[_replyingToIndex]['altYorumlar'].add({
          "ad": "Sen",
          "text": _commentController.text,
          "isMe": true,
          "tarih": simdi,
          "avatarColor": Colors.blue,
        });
      }
      // 3. DURUM: YENİ YORUM (NEW)
      else {
        _yorumlar.insert(0, {
          "ad": "Sen",
          "text": _commentController.text,
          "isMe": true,
          "tarih": simdi,
          "avatarColor": Colors.blue,
          "altYorumlar": []
        });
      }

      _cancelAction(); // Temizle
    });
  }

  // Yanıtla Başlat
  void _startReply(int index, String userName) {
    setState(() {
      _replyingToIndex = index;
      _editingTarget = null;
      _commentController.clear();
    });
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // --- TEK YORUM SATIRI (Widget) ---
  // mainIndex ve subIndex parametrelerini ekledik ki hangi satır olduğunu bilelim
  Widget _buildCommentRow(Map<String, dynamic> yorum, int mainIndex, int subIndex) {
    final bool isMe = yorum['isMe'];
    final bool isReply = subIndex != -1; // -1 değilse alt yorumdur

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isReply ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isMe ? Colors.blue.withOpacity(0.3) : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: yorum['avatarColor'],
                child: Text(yorum['ad'][0], style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Text(
                  yorum['ad'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: isMe ? Colors.blue.shade800 : Colors.black87)
              ),
              const Spacer(),

              // --- BURASI DEĞİŞTİ: KENDİ YORUMUMSA MENÜ GÖSTER ---
              if (isMe)
                SizedBox(
                  height: 24,
                  width: 24,
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.more_horiz, size: 20, color: Colors.grey.shade600),
                    onSelected: (value) {
                      if (value == 'edit') _startEdit(mainIndex, subIndex, yorum['text']);
                      if (value == 'delete') _deleteComment(mainIndex, subIndex);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        height: 32,
                        child: Row(children: [Icon(Icons.edit, size: 16), SizedBox(width: 8), Text("Düzenle", style: TextStyle(fontSize: 13))]),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        height: 32,
                        child: Row(children: [Icon(Icons.delete, size: 16, color: Colors.red), SizedBox(width: 8), Text("Sil", style: TextStyle(fontSize: 13, color: Colors.red))]),
                      ),
                    ],
                  ),
                )
              else
              // Başkasıysa sadece tarih göster
                Text(yorum['tarih'], style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
            ],
          ),

          const SizedBox(height: 6),
          Text(yorum['text'], style: const TextStyle(fontSize: 14)),

          // --- YANITLA BUTONU (Sadece başkasına ve ana yoruma) ---
          if (!isReply && !isMe)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: InkWell(
                  onTap: () => _startReply(mainIndex, yorum['ad']),
                  child: Text("Yanıtla", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue.shade600)),
                ),
              ),
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Edit modunda mıyız kontrolü
    bool isEditing = _editingTarget != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // KART ÜST KISIM
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(20)),
                child: Text(widget.etiket, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue.shade800, fontSize: 12)),
              ),
              Text("${_yorumlar.length} Konu", style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
            ],
          ),
          const SizedBox(height: 12),
          Text(widget.baslik, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(widget.aciklama, maxLines: _isExpanded ? null : 1, overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade600)),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.yazarBilgisi, style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              InkWell(
                onTap: _toggleExpand,
                child: Row(children: [Text(_isExpanded ? "Gizle" : "Cevapla", style: const TextStyle(fontWeight: FontWeight.bold)), Icon(_isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)]),
              ),
            ],
          ),

          // --- AÇILAN ALAN ---
          if (_isExpanded) ...[
            const Divider(height: 30),

            // 1. INPUT ÜSTÜ BİLGİ (Editliyor mu? Yanıtlıyor mu?)
            if (_replyingToIndex != -1 || isEditing)
              Container(
                margin: const EdgeInsets.only(bottom: 5),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    color: isEditing ? Colors.orange.shade50 : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(8)
                ),
                child: Row(
                  children: [
                    Icon(isEditing ? Icons.edit : Icons.reply, size: 16, color: isEditing ? Colors.orange.shade800 : Colors.blue.shade700),
                    const SizedBox(width: 5),
                    Text(
                        isEditing ? "Yorumunu düzenliyorsun" : "${_yorumlar[_replyingToIndex]['ad']} adlı kişiye yanıt veriyorsun",
                        style: TextStyle(fontSize: 11, color: isEditing ? Colors.orange.shade900 : Colors.blue.shade800, fontWeight: FontWeight.bold)
                    ),
                    const Spacer(),
                    InkWell(onTap: _cancelAction, child: Icon(Icons.close, size: 16, color: isEditing ? Colors.orange.shade900 : Colors.red))
                  ],
                ),
              ),

            // 2. INPUT ALANI
            Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isEditing ? Colors.orange.shade50 : Colors.grey.shade100, // Edit modunda turuncu
                borderRadius: BorderRadius.circular(25),
                border: isEditing ? Border.all(color: Colors.orange.shade200) : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _commentController,
                      decoration: InputDecoration(
                        hintText: isEditing ? "Metni düzenle..." : "Bir şeyler yaz...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: InputBorder.none,
                        hintStyle: TextStyle(color: Colors.grey.shade500),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _handleSubmit,
                    icon: CircleAvatar(
                        backgroundColor: isEditing ? Colors.orange : Colors.black,
                        radius: 15,
                        child: Icon(isEditing ? Icons.check : Icons.arrow_upward, color: Colors.white, size: 16)
                    ),
                  )
                ],
              ),
            ),

            // 3. YORUMLAR LİSTESİ
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _yorumlar.length,
              itemBuilder: (context, mainIndex) {
                final anaYorum = _yorumlar[mainIndex];
                List altYorumlar = anaYorum['altYorumlar'] ?? [];

                return Column(
                  children: [
                    // ANA YORUM (subIndex = -1)
                    _buildCommentRow(anaYorum, mainIndex, -1),

                    // ALT YORUMLAR
                    if (altYorumlar.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(left: BorderSide(color: Colors.grey.shade300, width: 2))
                          ),
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            // Alt yorumları dönerken indexlerini (key) alıyoruz
                            children: altYorumlar.asMap().entries.map((entry) {
                              int subIndex = entry.key;
                              Map<String, dynamic> altYorum = entry.value;
                              return _buildCommentRow(altYorum, mainIndex, subIndex);
                            }).toList(),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ]
        ],
      ),
    );
  }
}
