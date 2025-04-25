import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LayananDesaCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  const LayananDesaCard({super.key, required this.title, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap, // Trigger aksi saat diklik
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.all(12),
          constraints: const BoxConstraints(minHeight: 111),
          decoration: BoxDecoration(
            color: Colors.green.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
