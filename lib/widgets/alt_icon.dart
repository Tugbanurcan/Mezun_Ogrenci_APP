import 'package:flutter/material.dart';

class AltIcon extends StatelessWidget {
  final String? resimYolu;
  final IconData? ikon;
  final String label;
  final bool isSelected; // Seçili mi
  final VoidCallback? onTap; // Tıklama olayı

  const AltIcon({
    this.resimYolu,
    this.ikon,
    required this.label,
    this.isSelected = false,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? Colors.blueAccent : Colors.black54;

    return GestureDetector(
        onTap: onTap,
        child: SizedBox(
            width: 70,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                resimYolu != null
                    ? Image.asset(resimYolu!, width: 26, height: 26)
                    : Icon(
                  ikon ?? Icons.image_outlined,
                  color: color,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
             ),
         );
     }
}
