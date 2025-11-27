import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';

import '../providers/user_provider.dart';
import 'profie_edit_screen.dart';

// Renk Paleti (Sabitler)
const Color kPrimaryColor = Color(0xFFA65DD4);
const Color kSecondaryColor = Color.fromARGB(104, 105, 27, 154);
const Color kBackgroundColor = Color(0xFFF8F9FA);

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
                    action: IconButton(
                      icon: const Icon(Icons.add_circle, color: kPrimaryColor),
                      onPressed: () => _showAddSkillDialog(context, ref),
                    ),
                    content: _buildSkillsWrap(userProfile.skills),
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

  Widget _buildSkillsWrap(List<String> skills) {
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
        return Container(
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
        );
      }).toList(),
    );
  }

  // YENİ: Küçük İkon Tasarımı (İsmin yanına sığması için)
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
            child: const Text('İptal', style: TextStyle(color: Colors.grey)),
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
              if (controller.text.trim().isNotEmpty) {
                ref
                    .read(userProfileNotifierProvider.notifier)
                    .addSkill(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }
}
