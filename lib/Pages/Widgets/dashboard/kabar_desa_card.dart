import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:elades20/Pages/Screens/Berita/KabarDesaDetailDialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elades20/Services/config.dart';

class KabarDesaCard extends StatelessWidget {
  final KabarDesaModel kabarDesa;

  const KabarDesaCard({super.key, required this.kabarDesa});

  @override
  Widget build(BuildContext context) {
    // Format tanggal ke format Indonesia
    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    final String formattedDate = formatter.format(kabarDesa.tanggal);

    // Construct the image URL properly
    String imageUrl = "";
    if (kabarDesa.gambar.isNotEmpty) {
      // Clean up the image path first
      String cleanPath = kabarDesa.gambar;
      
      // Remove any leading '../' or './'
      cleanPath = cleanPath.replaceAll(RegExp(r'^\.\.\/'), '');
      cleanPath = cleanPath.replaceAll(RegExp(r'^\.\/'), '');
      
      // If path already contains 'uploads/gambar_kabar_desa/', extract just the filename
      if (cleanPath.contains('uploads/gambar_kabar_desa/')) {
        // Extract filename after the last '/'
        List<String> pathParts = cleanPath.split('/');
        String filename = pathParts.last;
        cleanPath = filename;
      }
      
      // Now construct the proper URL
      String encodedFilename = Uri.encodeComponent(cleanPath);
      imageUrl = "${AppConfig.uploads}/uploads/gambar_kabar_desa/$encodedFilename";
      
      // Debug log the image URL
      print("KabarDesaCard: Original path: ${kabarDesa.gambar}");
      print("KabarDesaCard: Cleaned path: $cleanPath");
      print("KabarDesaCard: Final URL: $imageUrl");
    }

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade300,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar jika ada
          if (kabarDesa.gambar.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/images/placeholder.png',
                image: imageUrl,
                width: double.infinity,
                height: 150,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  print("KabarDesaCard: Error loading image: $error for URL: $imageUrl");
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                          const SizedBox(height: 8),
                          Text(
                            'Gambar tidak tersedia',
                            style: GoogleFonts.inter(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // Konten
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Judul
                Text(
                  kabarDesa.judul,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 4),

                // Tanggal
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const SizedBox(height: 8),

                // Deskripsi
                Text(
                  kabarDesa.deskripsi,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.white,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Tombol Baca Selengkapnya
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        // Tampilkan popup dialog detail kabar desa
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return KabarDesaDetailDialog(kabarDesa: kabarDesa);
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF4B9560),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Baca Selengkapnya',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}