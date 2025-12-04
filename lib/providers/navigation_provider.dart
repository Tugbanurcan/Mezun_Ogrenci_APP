import 'package:flutter_riverpod/flutter_riverpod.dart';

// Navigation state provider
final navigationProvider = StateNotifierProvider<NavigationNotifier, int>((
  ref,
) {
  return NavigationNotifier();
});

class NavigationNotifier extends StateNotifier<int> {
  NavigationNotifier() : super(2); // Default to Ana Sayfa (index 2)

  void setIndex(int index) {
    state = index;
  }
}
