import 'package:flutter_riverpod/flutter_riverpod.dart';

// Saved Jobs Provider
final savedJobsProvider =
    StateNotifierProvider<SavedJobsNotifier, List<Map<String, dynamic>>>((ref) {
      return SavedJobsNotifier();
    });

class SavedJobsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  SavedJobsNotifier() : super([]);

  // Add job to saved list
  void addSavedJob(Map<String, dynamic> job) {
    if (!state.any(
      (savedJob) =>
          savedJob['title'] == job['title'] &&
          savedJob['company'] == job['company'],
    )) {
      state = [...state, job];
    }
  }

  // Remove job from saved list
  void removeSavedJob(Map<String, dynamic> job) {
    state = state
        .where(
          (savedJob) =>
              !(savedJob['title'] == job['title'] &&
                  savedJob['company'] == job['company']),
        )
        .toList();
  }

  // Check if job is saved
  bool isJobSaved(Map<String, dynamic> job) {
    return state.any(
      (savedJob) =>
          savedJob['title'] == job['title'] &&
          savedJob['company'] == job['company'],
    );
  }

  // Toggle save/unsave
  void toggleSavedJob(Map<String, dynamic> job) {
    if (isJobSaved(job)) {
      removeSavedJob(job);
    } else {
      addSavedJob(job);
    }
  }
}
