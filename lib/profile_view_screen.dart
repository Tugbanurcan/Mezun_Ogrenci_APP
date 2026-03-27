import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:untitled4/forum_ekle_page.dart';
import 'package:untitled4/login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../providers/user_provider.dart';
import 'profile_edit_screen.dart';
import 'is_staj_page.dart';
import 'community_page.dart';
import 'is_staj_ekle_page.dart';
import 'etkinlikler_page.dart';

// Renk Paleti
const Color kPrimaryColor = Color.fromARGB(255, 0, 0, 0);
const Color kSecondaryColor = Color.fromARGB(119, 255, 255, 255);
const Color kBackgroundColor = Color.fromARGB(255, 255, 255, 255);

class ProfileViewScreen extends ConsumerWidget {
  const ProfileViewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 22),
              onPressed: () => _navigateToEditProfile(context),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ÜST KISIM (Header + Avatar) - BURASI AYNI KALDI
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Arka Plan Gradient
                Container(
                  height: size.height * 0.28,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color.fromARGB(25, 105, 27, 154), kPrimaryColor],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                // Profil Fotoğrafı
                Positioned(
                  bottom: -60,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: kBackgroundColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 65,
                      backgroundColor: Colors.grey.shade200,
                      backgroundImage: userProfile.photoPath != null
                          ? FileImage(File(userProfile.photoPath!))
                          : null,
                      child: userProfile.photoPath == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.grey.shade400,
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 70), // Avatar boşluğu
            // --- DEĞİŞİKLİK BURADA YAPILDI ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // İsim ve İkonlar YAN YANA (Row)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center, // Ortala
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 1. İsim
                      Flexible(
                        child: Text(
                          userProfile.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),

                      // 2. Sosyal İkonlar (İsmin yanına)
                      if (userProfile.linkedin.isNotEmpty ||
                          userProfile.github.isNotEmpty) ...[
                        const SizedBox(width: 10), // İsimle ikon arasına boşluk

                        if (userProfile.linkedin.isNotEmpty)
                          _buildSmallSocialIcon(
                            FontAwesomeIcons.linkedinIn,
                            const Color(0xFF0077B5),
                            userProfile.linkedin,
                            context,
                          ),

                        if (userProfile.linkedin.isNotEmpty &&
                            userProfile.github.isNotEmpty)
                          const SizedBox(width: 8), // İki ikon arası boşluk

                        if (userProfile.github.isNotEmpty)
                          _buildSmallSocialIcon(
                            FontAwesomeIcons.github,
                            const Color(0xFF333333),
                            userProfile.github,
                            context,
                          ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 5),

                  // 3. Unvan (İsmin Altında)
                  Text(
                    userProfile.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // --- DEĞİŞİKLİK SONU ---
            const SizedBox(height: 25),

            // KARTLAR (BİLGİLER)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildContentCard(
                    title: "Hakkında",
                    icon: Icons.info_outline,
                    content: Text(
                      userProfile.about,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ),
                  _buildContentCard(
                    title: "Yetkinlikler",
                    icon: Icons.star_border,
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Düzenle Butonu (Kalem)
                        IconButton(
                          icon: const Icon(Icons.edit, color: kPrimaryColor),
                          tooltip: "Düzenle",
                          onPressed: () => _showManageSkillsDialog(
                            context,
                            ref,
                            userProfile.skills,
                          ),
                        ),
                        // 2. Ekle Butonu (Artı)
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: kPrimaryColor,
                          ),
                          tooltip: "Ekle",
                          onPressed: () => _showAddSkillDialog(context, ref),
                        ),
                      ],
                    ),
                    content: _buildSkillsWrap(userProfile.skills, context, ref),
                  ),
                  _buildContentCard(
                    title: "Eğitim",
                    icon: Icons.school_outlined,
                    content: Text(
                      userProfile.education,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),

                  _buildContentCard(
                    title: "İletişim",
                    icon: Icons.mail,
                    content: Text(
                      userProfile.communication,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        height: 1.4,
                      ),
                    ),
                  ),

                  _buildContentCard(
                    title: "İş & Staj",
                    icon: Icons.work_outline,
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. İlan Ekleme Butonu
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black87,
                          ),
                          tooltip: "İlan Ekle",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const IsStajEklePage(),
                              ),
                            );
                          },
                        ),
                        // 2. Sayfaya Gitme Butonu
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: kPrimaryColor,
                          ),
                          tooltip: "İlanlara Git",
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const IsStajPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: const Text(
                      "İş ve staj ilanlarını görüntüleyin veya yeni bir ilan paylaşın.",
                      style: TextStyle(color: Colors.grey, height: 1.4),
                    ),
                  ),

                  _buildContentCard(
                    title: "Forum",
                    icon: Icons.forum_outlined,
                    // ACTION KISMI GÜNCELLENDİ 👇
                    action: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // 1. Forum Konusu Ekleme Butonu
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle_outline,
                            color: Colors.black87,
                          ),
                          tooltip: "Konu Başlat",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForumEklePage(),
                              ),
                            );
                          },
                        ),
                        // 2. Sayfaya Gitme Butonu
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: kPrimaryColor,
                          ),
                          tooltip: "Foruma Git",
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CommunityPage(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: const Text(
                      "Topluluk forumlarına katılın, sorular sorun veya yeni bir tartışma başlatın.",
                      style: TextStyle(color: Colors.grey, height: 1.4),
                    ),
                  ),
                  // --- BURAYA EKLE: ÇIKIŞ YAP BUTONU ---
                  const SizedBox(height: 35),
                  Center(
                    child: InkWell(
                      onTap: () => _showLogoutDialog(context),
                      borderRadius: BorderRadius.circular(15),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color.fromARGB(
                              255,
                              0,
                              0,
                              0,
                            ).withOpacity(0.3),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize
                              .min, // Sadece içeriği kadar kaplasın (Estetik durur)
                          children: [
                            Icon(
                              Icons.power_settings_new_rounded,
                              color: const Color.fromARGB(255, 0, 0, 0),
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Çıkış Yap",
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ), // Sayfanın en altında boşluk kalsın, sıkışmasın
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentCard({
    required String title,
    required IconData icon,
    required Widget content,
    Widget? action,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, color: kPrimaryColor, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              if (action != null) action,
            ],
          ),
          const Divider(height: 25, thickness: 0.5),
          content,
        ],
      ),
    );
  }

  Widget _buildSkillsWrap(
    List<String> skills,
    BuildContext context,
    WidgetRef ref,
  ) {
    if (skills.isEmpty) {
      return const Text(
        "Henüz yetkinlik eklenmemiş.",
        style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return GestureDetector(
          onLongPress: () {
            // Artık parametre olarak gelen 'context'i kullanabilir
            _showDeleteConfirmDialog(context, ref, skill);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: kPrimaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kPrimaryColor.withOpacity(0.3)),
            ),
            child: Text(
              skill,
              style: const TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSmallSocialIcon(
    IconData icon,
    Color color,
    String handle,
    BuildContext context,
  ) {
    String url = (icon == FontAwesomeIcons.linkedinIn)
        ? 'https://www.linkedin.com/in/$handle'
        : 'https://github.com/$handle';

    return GestureDetector(
      onTap: () => _launchUrlSafely(url, context),
      child: Container(
        width: 32, // Küçük boyut
        height: 32,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1), // Hafif renkli arka plan
          shape: BoxShape.circle,
        ),
        child: Center(
          child: FaIcon(icon, color: color, size: 16), // İkon boyutu küçük
        ),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );
  }

  void _launchUrlSafely(String urlString, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(urlString);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Bağlantı açılamadı: $e')));
      }
    }
  }

  void _showAddSkillDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          'Yetkinlik Ekle',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Örn: Flutter, Python, Dart...',
            filled: true,
            fillColor: Colors.grey.shade50,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'İptal',
              style: TextStyle(color: Color.fromARGB(209, 0, 0, 0)),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              final trimmedSkill = controller.text.trim();
              if (trimmedSkill.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Yetkinlik adı boş olamaz.')),
                  );
                }
                return;
              }
              final currentSkills = ref
                  .read(userProfileNotifierProvider)
                  .skills;
              if (currentSkills.contains(trimmedSkill)) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bu yetkinlik zaten mevcut.')),
                  );
                }
                return;
              }
              ref
                  .read(userProfileNotifierProvider.notifier)
                  .addSkill(trimmedSkill);
              Navigator.pop(context);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Yetkinlik başarıyla eklendi.')),
                );
              }
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
    String skillToDelete,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Yetkinlik Sil"),
          content: Text("Yetkinliğini silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: const Text("İptal"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Sil", style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref
                    .read(userProfileNotifierProvider.notifier)
                    .deleteSkill(skillToDelete);

                Navigator.of(context).pop(); // Pencereyi kapat
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Yetkinlik başarıyla silindi.'),
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Yetkinlikleri Yönetme Penceresi
  void _showManageSkillsDialog(
    BuildContext context,
    WidgetRef ref,
    List<String> currentSkills,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            final skills = ref.watch(userProfileNotifierProvider).skills;

            return AlertDialog(
              title: const Text(
                "Yetkinlikleri Düzenle",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: skills.isEmpty
                    ? const Center(child: Text("Hiç yetkinlik yok."))
                    : ListView.builder(
                        itemCount: skills.length,
                        itemBuilder: (context, index) {
                          final skill = skills[index];
                          return ListTile(
                            title: Text(skill),
                            // Yan yana Düzenle ve Sil butonları
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // DÜZENLEME BUTONU (Kalem)
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: kPrimaryColor,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context); // Listeyi kapat

                                    _showEditSingleSkillDialog(context, skill);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () => _showDeleteConfirmDialog(
                                    context,
                                    ref,
                                    skill,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kapat"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Tek Bir Yetkinliği Düzenleme Penceresi
  void _showEditSingleSkillDialog(BuildContext context, String oldSkill) {
    TextEditingController controller = TextEditingController(text: oldSkill);

    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, child) {
            return AlertDialog(
              title: const Text("Yetkinliği Düzenle"),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Yeni isim giriniz",
                ),
                autofocus: true, // Klavye otomatik açılsın
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("İptal"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      ref
                          .read(userProfileNotifierProvider.notifier)
                          .updateSkill(oldSkill, controller.text);
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Kaydet"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black.withOpacity(0.6),
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 40,
                    spreadRadius: 0,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // --- İkon Alanı ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 36, bottom: 20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(28),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFD32F2F),
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- İçerik ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(28, 24, 28, 8),
                    child: Column(
                      children: [
                        Text(
                          "Çıkış Yap",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Oturumunuz sonlandırılacaktır.\nEmin misiniz?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.55,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Butonlar ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                    child: Row(
                      children: [
                        // Vazgeç
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(context),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                                side: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant,
                                ),
                              ),
                            ),
                            child: Text(
                              "Vazgeç",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Çıkış Yap
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: const Text(
                              "Çıkış Yap",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
