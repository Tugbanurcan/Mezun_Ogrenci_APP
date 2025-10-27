import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // pubspec.yaml'a eklemeyi unutmayın!
import 'dart:ui';
import 'dart:io';

import '../providers/user_provider.dart';
import 'profie_edit_screen.dart';
import '';

class ProfileViewScreen extends ConsumerWidget {
  const ProfileViewScreen({super.key});

  static const double _padding = 20.0;
  static const double _avatarSize = 100.0;
  static const double _spacingSmall = 8.0;
  static const double _spacingMedium = 16.0;
  static const double _titleFontSize = 24.0;
  static const double _subtitleFontSize = 18.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(),
      body: _buildBody(context, ref, userProfile),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToEditProfile(context),
        backgroundColor: const Color.fromARGB(255, 166, 93, 212),
        shape: const CircleBorder(),
        elevation: 8,
        child: const Icon(Icons.edit, color: Colors.white, size: 24),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(0.4),
      elevation: 0,
      toolbarHeight: 50,
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.2),
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(bottom: 6.0), // Yazıyı biraz yukarı taşı
        child: const Text(
          'Profilim',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, userProfile) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: _spacingMedium),
          _buildProfileAvatar(userProfile),
          const SizedBox(height: _spacingMedium),
          _buildProfileHeader(context, ref, userProfile),
          const SizedBox(height: _spacingMedium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: _padding),
            child: _buildProfileSections(context, ref, userProfile),
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildProfileAvatar(userProfile) {
    return Center(
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          image: userProfile.photoPath != null
              ? DecorationImage(
            image: FileImage(File(userProfile.photoPath!)),
            fit: BoxFit.cover,
          )
              : null,
        ),
        child: userProfile.photoPath == null
            ? const Icon(Icons.person, size: 50, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, WidgetRef ref, userProfile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _padding),
      child: Column(
        children: [
          Text(
            userProfile.name,
            style: const TextStyle(
              fontSize: _titleFontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: _spacingSmall / 2),
          Text(
            userProfile.title,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: _spacingMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialIcon(
                FontAwesomeIcons.linkedinIn,
                Colors.blueAccent,
                userProfile.linkedin,
                context,
              ),
              const SizedBox(width: _spacingMedium),
              _buildSocialIcon(
                FontAwesomeIcons.github,
                Colors.black,
                userProfile.github,
                context,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _launchUrlSafely(String urlString, BuildContext context) async {
    try {
      final Uri uri = Uri.parse(urlString);

      // Dış tarayıcıda aç
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bağlantı açılırken hata: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildSocialIcon(
      IconData icon,
      Color color,
      String handle,
      BuildContext context,
      ) {
    String platform = (icon == FontAwesomeIcons.linkedinIn)
        ? 'https://www.linkedin.com/in/$handle'
        : 'https://github.com/$handle';

    return InkWell(
      onTap: () => _launchUrlSafely(platform, context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withOpacity(0.1),
        ),
        child: Center(child: FaIcon(icon, color: color, size: 20)),
      ),
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileEditScreen()),
    );
  }

  void _showAddSkillDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Yetkinlik Ekle'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Yetkinlik adı',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final skill = controller.text.trim();
              if (skill.isNotEmpty) {
                ref.read(userProfileNotifierProvider.notifier).addSkill(skill);
              }
              Navigator.pop(context);
            },
            child: const Text('Ekle'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSections(
      BuildContext context, WidgetRef ref, userProfile) {
    return Column(
      children: [
        _buildInfoSection(
          context,
          title: 'Hakkında',
          content: userProfile.about,
          showSectionActions: false,
        ),
        _buildInfoSection(
          context,
          title: 'Yetkinlikler',
          contentWidget: _buildSkillsRow(userProfile.skills),
          onAdd: () => _showAddSkillDialog(context, ref),
        ),
        _buildInfoSection(
          context,
          title: 'Eğitim',
          content: userProfile.education,
          showSectionActions: false,
          onAdd: () => print('Yeni Eğitim Ekle'),
        ),
      ],
    );
  }

  Widget _buildInfoSection(
      BuildContext context, {
        required String title,
        String? content,
        Widget? contentWidget,
        bool showSectionActions = true,
        VoidCallback? onAdd,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: _spacingMedium),
      child: Container(
        padding: const EdgeInsets.all(_padding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              spreadRadius: 0,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: _subtitleFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                if (showSectionActions)
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 24,
                      color: Colors.black54,
                    ),
                    onPressed: onAdd,
                    tooltip: 'Yeni ${title} Ekle',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: _spacingSmall),
            if (content != null)
              Text(
                content,
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
            if (contentWidget != null) contentWidget,
          ],
        ),
      ),
    );
  }

  Widget _buildSkillsRow(List<String> skills) {
    return Wrap(
      spacing: _spacingSmall,
      runSpacing: _spacingSmall,
      children: skills
          .map(
            (skill) =>
            _buildSkillChip(skill, const Color.fromARGB(255, 166, 93, 212)),
      )
          .toList(),
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Chip(
        label: Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        backgroundColor: color.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        );
  }
}
