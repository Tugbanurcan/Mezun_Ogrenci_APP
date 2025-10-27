import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model
class UserProfile {
  final String name;
  final String title;
  final String about;
  final String linkedin;
  final String github;
  final String education;
  final List<String> skills;
  final String? photoPath; // ← Bunu ekledik

  UserProfile({
    required this.name,
    required this.title,
    required this.about,
    required this.linkedin,
    required this.github,
    required this.education,
    required this.skills,
    this.photoPath, // ← opsiyonel
  });

  UserProfile copyWith({
    String? name,
    String? title,
    String? about,
    String? linkedin,
    String? github,
    String? education,
    List<String>? skills,
    String? photoPath, // ← Bunu ekledik
  }) {
    return UserProfile(
      name: name ?? this.name,
      title: title ?? this.title,
      about: about ?? this.about,
      linkedin: linkedin ?? this.linkedin,
      github: github ?? this.github,
      education: education ?? this.education,
      skills: skills ?? this.skills,
      photoPath: photoPath ?? this.photoPath, // ← Bunu ekledik
    );
  }
}

// Notifier
class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(UserProfile(
    name: '',
    title: '',
    about: '',
    linkedin: '',
    github: '',
    education: '',
    skills: [],
  ));

  // Profil güncelleme metodu
  void updateProfile({
    String? name,
    String? title,
    String? about,
    String? linkedin,
    String? github,
    String? education,
  }) {
    state = state.copyWith(
      name: name,
      title: title,
      about: about,
      linkedin: linkedin,
      github: github,
      education: education,
    );
  }

  // Yetkinlik ekleme
  void addSkill(String skill) {
    state = state.copyWith(skills: [...state.skills, skill]);
  }
}

// Provider
final userProfileNotifierProvider =
StateNotifierProvider<UserProfileNotifier, UserProfile>(
      (ref) => UserProfileNotifier(),
);