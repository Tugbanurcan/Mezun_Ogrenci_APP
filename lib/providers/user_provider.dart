import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';

// 1. Notifier Tanımı
class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier()
      : super(
    UserProfile(
      name: '',
      title: '',
      about: '',
      linkedin: '',
      github: '',
      education: '',
      skills: [],
    ),
  );

  // Bu metodu ekle:
  void updateProfile({
    String? name,
    String? title,
    String? about,
    String? linkedin,
    String? github,
    String? education,
    String? photoPath,
  }) {
    state = state.copyWith(
      name: name ?? state.name,
      title: title ?? state.title,
      about: about ?? state.about,
      linkedin: linkedin ?? state.linkedin,
      github: github ?? state.github,
      education: education ?? state.education,
      photoPath: photoPath ?? state.photoPath,
    );
  }

  // Yetkinlik eklemek için
  void addSkill(String skill) {
    state = state.copyWith(skills: [...state.skills, skill]);
  }
}

// 2. Provider Tanımı
final userProfileNotifierProvider =
StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
