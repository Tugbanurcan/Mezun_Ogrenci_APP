import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart'; // ← YENİ: servis dosyası
import 'widgets/bottom_nav_bar.dart';
import 'community_page.dart';
import 'is_staj_page.dart';
import 'etkinlikler_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    // Sayfa açılınca 24 saatten eski bildirimleri Firestore'dan sil
    NotificationService.deleteOlderThan24h();
  }

  // Zaman formatlama (aynı kalıyor)
  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Az önce";
    final date = timestamp.toDate();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Az önce";
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} sa önce";
    return "${date.day}/${date.month}/${date.year}";
  }

  void _handleNotificationClick(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final String type = data['type'] ?? "";
    final String? relatedId = data['relatedId'];

    if (relatedId == null) return;

    // 1. Forum ile ilgili bildirimler (Yorum veya Yanıt)
    if (type == "forum_comment" || type == "forum_reply") {
      // Önce forumun verilerini Firestore'dan çekmemiz lazım
      // Çünkü ForumModernKart bizden 'data' bekliyor
      final forumDoc = await FirebaseFirestore.instance
          .collection('forums')
          .doc(relatedId)
          .get();

      if (forumDoc.exists && mounted) {
        final forumData = forumDoc.data() as Map<String, dynamic>;

        // Burası kritik: Kullanıcıyı CommunityPage'e gönderip,
        // orada otomatik olarak o forumun yorumlar panelini açtırabiliriz.
        // Ama en basiti, direkt CommunityPage'e yönlendirmektir.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CommunityPage()),
        );

        // Not: Eğer spesifik olarak o forumun yorumlarını açtırmak istersen
        // CommunityPage'e bir 'initialForumId' parametresi eklememiz gerekir.
      }
    }
    // 2. İş/Staj bildirimi
    else if (type == "new_job") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const IsStajPage()),
      );
    }
    // 3. Etkinlik bildirimi
    else if (type == "new_event") {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EtkinliklerPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Bildirimler"),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) async {
              if (value == "read") {
                // ESKİ: markAllAsRead() → YENİ: Firestore'a yaz
                await NotificationService.markAllAsRead();
              } else if (value == "delete") {
                // ESKİ: deleteAllNotifications() → YENİ: Firestore'dan sil
                await NotificationService.deleteAll();
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: "read",
                child: Text("Tümünü Okundu İşaretle"),
              ),
              PopupMenuItem(value: "delete", child: Text("Tümünü Sil")),
            ],
          ),
        ],
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: NotificationService.streamForCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_none_outlined,
                    size: 72,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Henüz bildirim yok",
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final bool isRead = data['isRead'] ?? false;
              final String notifId = doc.id;

              return Dismissible(
                // ESKİ: UniqueKey() → YENİ: ValueKey(notifId) — daha stabil
                key: ValueKey(notifId),
                direction: DismissDirection.startToEnd,
                background: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  color: Colors.red,
                  child: const Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                onDismissed: (_) async {
                  // ESKİ: notifications.removeAt(index)
                  // YENİ: Firestore'dan sil
                  await NotificationService.delete(notifId);

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Bildirim silindi"),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 1),
                      ),
                    );
                  }
                },
                child: GestureDetector(
                  onTap: () async {
                    // 1. Bildirimi okundu işaretle (Zaten kodunda vardı)
                    await NotificationService.markAsRead(notifId);

                    // 2. İlgili sayfaya yönlendir
                    if (mounted) {
                      _handleNotificationClick(context, data);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      // ESKİ: notif["isRead"] → YENİ: data['isRead']
                      color: isRead
                          ? const Color(0xFFF2F2F2)
                          : const Color(0xFFE8D5FF),
                      border: Border.all(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ESKİ: notif["icon"] → YENİ: data['icon']
                        Text(
                          data['icon'] ?? "🔔",
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // ESKİ: notif["title"] → YENİ: data['title']
                              Text(
                                data['title'] ?? "",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                                  color: isRead
                                      ? Colors.black54
                                      : Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // YENİ: zaman damgası eklendi
                              Text(
                                _formatTimestamp(
                                  data['timestamp'] as Timestamp?,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // YENİ: okunmadı noktası
                        if (!isRead)
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(top: 4),
                            decoration: const BoxDecoration(
                              color: Colors.deepPurple,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),

      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
