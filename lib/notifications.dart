import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';
import 'widgets/bottom_nav_bar.dart';
import 'community_page.dart';
import 'is_staj_page.dart';
import 'etkinlikler_page.dart';
import 'chat_page.dart';
import 'chat_detail_page.dart';

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
    NotificationService.deleteOlderThan24h();
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return "Az önce";
    final date = timestamp.toDate();
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return "Az önce";
    if (diff.inMinutes < 60) return "${diff.inMinutes} dk önce";
    if (diff.inHours < 24) return "${diff.inHours} sa önce";
    return "${date.day}/${date.month}/${date.year}";
  }

  Future<void> _handleNotificationClick(
    BuildContext context,
    Map<String, dynamic> data,
  ) async {
    final String type = data['type'] ?? "";
    final String? relatedId = data['relatedId'];

    switch (type) {
      // ── Forum yorumu veya yanıtı ──────────────────────────────────────
      // HATA DÜZELTİLDİ: targetForumId artık geçiriliyor
      case "forum_comment":
      case "forum_reply":
        if (relatedId == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityPage(targetForumId: relatedId), // ✅
          ),
        );
        break;

      // ── Yeni iş/staj ilanı ───────────────────────────────────────────
      case "new_job":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IsStajPage()),
        );
        break;

      // ── Yeni etkinlik ────────────────────────────────────────────────
      case "new_event":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EtkinliklerPage()),
        );
        break;

      // ── Mesaj bildirimi ──────────────────────────────────────────────
      // HATA DÜZELTİLDİ: new_message artık ele alınıyor
      case "new_message":
        if (relatedId == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              chatId: relatedId,
              isim: data['senderName'] ?? "Mesaj", // bildirimde senderName var
            ),
          ),
        );
        break;

      // ── Mentör başvurusu onaylandı ───────────────────────────────────
      // HATA DÜZELTİLDİ: mentor bildirimleri artık ele alınıyor
      case "mentor_approved":
        _showMentorResultDialog(context, approved: true);
        break;

      // ── Mentör başvurusu reddedildi ──────────────────────────────────
      case "mentor_rejected":
        _showMentorResultDialog(context, approved: false);
        break;

      // ── Admin'e gelen mentör talebi bildirimi ────────────────────────
      case "mentor_request":
        // relatedId burada başvuran kullanıcının userId'si
        // Admin paneli varsa buradan açılabilir:
        // Navigator.push(context, MaterialPageRoute(builder: (_) => const AdminMentorRequestsPage()));
        break;
    }
  }

  void _showMentorResultDialog(BuildContext context, {required bool approved}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              approved ? Icons.check_circle : Icons.cancel,
              color: approved ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8),
            Text(
              approved ? "Başvuru Onaylandı" : "Başvuru Reddedildi",
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: Text(
          approved
              ? "Tebrikler! Artık mentör olarak listeleniyorsunuz."
              : "Mentör başvurunuz şu an için onaylanmadı. Daha sonra tekrar başvurabilirsiniz.",
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Tamam",
              style: TextStyle(
                color: Color(0xFF4F46E5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
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
                await NotificationService.markAllAsRead();
              } else if (value == "delete") {
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
                    await NotificationService.markAsRead(notifId);
                    if (mounted) {
                      await _handleNotificationClick(context, data);
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
                      color: isRead
                          ? const Color(0xFFF2F2F2)
                          : const Color(0xFFE8D5FF),
                      border: Border.all(color: Colors.white, width: 1.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['icon'] ?? "🔔",
                          style: const TextStyle(fontSize: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
