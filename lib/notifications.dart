import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_service.dart';
import 'widgets/bottom_nav_bar.dart';
import 'community_page.dart';
import 'is_staj_page.dart';
import 'etkinlikler_page.dart';
import 'chat_detail_page.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    // initState içinde async işlem yaparken dikkatli olmalıyız
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

    if (!mounted) return;

    switch (type) {
      case "forum_comment":
      case "forum_reply":
        if (relatedId == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CommunityPage(targetForumId: relatedId),
          ),
        );
        break;
      case "new_job":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const IsStajPage()),
        );
        break;
      case "new_event":
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const EtkinliklerPage()),
        );
        break;
      case "new_message":
        if (relatedId == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatDetailPage(
              chatId: relatedId,
              isim: data['senderName'] ?? "Mesaj",
            ),
          ),
        );
        break;
      case "mentor_approved":
        _showMentorResultDialog(context, approved: true);
        break;
      case "mentor_rejected":
        _showMentorResultDialog(context, approved: false);
        break;
    }
  }

  // --- UI YARDIMCILARI ---
  PopupMenuItem<String> _buildPopupItem({
    required String value,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  void _showMentorResultDialog(BuildContext context, {required bool approved}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(approved ? "Başvuru Onaylandı" : "Başvuru Reddedildi"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Tamam"),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Hepsini Sil?"),
        content: const Text("Tüm bildirimler silinecektir."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Vazgeç"),
          ),
          TextButton(
            onPressed: () async {
              await NotificationService.deleteAll();
              if (mounted) Navigator.pop(ctx);
            },
            child: const Text("Sil", style: TextStyle(color: Colors.red)),
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
        elevation: 0,
        title: const Text("Bildirimler", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            icon: const Icon(Icons.more_horiz, color: Colors.black),
            onSelected: (val) {
              if (val == "read") NotificationService.markAllAsRead();
              if (val == "delete") _confirmDeleteAll(context);
            },
            itemBuilder: (ctx) => [
              _buildPopupItem(
                value: "read",
                icon: Icons.done_all,
                text: "Tümünü Oku",
                color: Colors.blue,
              ),
              _buildPopupItem(
                value: "delete",
                icon: Icons.delete_sweep,
                text: "Tümünü Sil",
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: NotificationService.streamForCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return Center(child: Text("Hata: ${snapshot.error}"));
          if (snapshot.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data?.docs ?? [];
          if (docs.isEmpty) {
            return const Center(
              child: Text(
                "Henüz bildirim yok",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: docs.length,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final bool isRead = data['isRead'] ?? false;
              final String id = docs[index].id;

              return Dismissible(
                key: Key(id),
                direction: DismissDirection.startToEnd,
                onDismissed: (_) => NotificationService.delete(id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: GestureDetector(
                  onTap: () {
                    NotificationService.markAsRead(id);
                    _handleNotificationClick(context, data);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isRead
                          ? Colors.grey[100]
                          : const Color(0xFFE8EAF6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Text(
                          data['icon'] ?? "🔔",
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? "",
                                style: TextStyle(
                                  fontWeight: isRead
                                      ? FontWeight.normal
                                      : FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _formatTimestamp(
                                  data['timestamp'] as Timestamp?,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!isRead)
                          const Icon(
                            Icons.circle,
                            color: Colors.indigo,
                            size: 10,
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
