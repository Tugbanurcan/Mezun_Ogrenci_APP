import 'package:flutter/material.dart';
import 'widgets/bottom_nav_bar.dart';
import 'etkinlikler_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const bordo = Colors.white;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bildirimler',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: bordo),
        appBarTheme: const AppBarTheme(
          backgroundColor: bordo,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      home: const NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Map<String, dynamic>> notifications = [
    {
      "icon": "💬",
      "title": "Ahmet size bir mesaj gönderdi",
      "time": DateTime.now(),
      "isRead": false,
    },
    {
      "icon": "🗓",
      "title": "Etkinlik duyurusu: Networking Atölyesi",
      "time": DateTime.now(),
      "isRead": false,
    },
    {
      "icon": "🎓",
      "title": "Yeni mentorluk talebi kabul edildi",
      "time": DateTime.now().subtract(const Duration(hours: 23)),
      "isRead": false,
    },
    {
      "icon": "📝",
      "title": "Turkcell yeni iş ilanı yayınlandı",
      "time": DateTime.now().subtract(
        const Duration(hours: 25),
      ), // otomatik silinsin
      "isRead": false,
    },
  ];

  // 🔥 24 Saatten eski bildirimleri temizle
  void removeOldNotifications() {
    setState(() {
      notifications.removeWhere((notif) {
        final notifTime = notif["time"] as DateTime;
        return DateTime.now().difference(notifTime).inHours >= 24;
      });
    });
  }

  // 📌 Tümünü okundu yap
  void markAllAsRead() {
    setState(() {
      for (var n in notifications) {
        n["isRead"] = true;
      }
    });
  }

  // 📌 Tümünü sil
  void deleteAllNotifications() {
    setState(() {
      notifications.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    removeOldNotifications(); // Sayfa açılınca eski bildirimleri sil
  }

  @override
  Widget build(BuildContext context) {
    const bordo = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Bildirimler"),

        // ✔️ SAĞ ÜSTTE 3 NOKTA MENÜ
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onSelected: (value) {
              if (value == "read") {
                markAllAsRead();
              } else if (value == "delete") {
                deleteAllNotifications();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: "read", child: Text("Tümünü Oku")),
              const PopupMenuItem(value: "delete", child: Text("Tümünü Sil")),
            ],
          ),
        ],
      ),

      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          final isRead = notif["isRead"] as bool;

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            background: Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white, size: 28),
            ),
            onDismissed: (direction) {
              setState(() {
                notifications.removeAt(index);
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Bildirim silindi"),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  notif["isRead"] = true;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: notif["isRead"]
                      ? const Color(0xFFF2F2F2)
                      : const Color(0xFFE8D5FF),
                  border: Border.all(color: Colors.white, width: 1.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(notif["icon"], style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        notif["title"],
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: notif["isRead"]
                              ? FontWeight.normal
                              : FontWeight.w600,
                          color: notif["isRead"]
                              ? Colors.black54
                              : Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),

      // 👇 Scaffold'un doğru kapanışı ve bottomNavigationBar buraya gelecek
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
