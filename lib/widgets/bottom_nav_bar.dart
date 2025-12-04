import 'package:flutter/material.dart';
import 'alt_icon.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AltIcon(
            ikon: Icons.chat,
            label: 'Chat',
            isSelected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          AltIcon(
            ikon: Icons.event,
            label: 'Etkinlikler',
            isSelected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
          AltIcon(
            ikon: Icons.home,
            label: 'Ana Sayfa',
            isSelected: currentIndex == 2,
            onTap: () => onTap(2),
          ),
          AltIcon(
            ikon: Icons.person_search,
            label: 'Mentor Bul',
            isSelected: currentIndex == 3,
            onTap: () => onTap(3),
          ),
          AltIcon(
            ikon: Icons.work_outline,
            label: 'İş & Staj',
            isSelected: currentIndex == 4,
            onTap: () => onTap(4),
          ),
        ],
      ),
    );
  }
}
