import 'package:flutter/material.dart';
import 'package:elades20/Models/dashboard/dashboard_model.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:elades20/Services/config.dart';

class KabarDesaDetailDialog extends StatelessWidget {
  final KabarDesaModel kabarDesa;

  const KabarDesaDetailDialog({super.key, required this.kabarDesa});

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
      print("KabarDesaDetailDialog: Original path: ${kabarDesa.gambar}");
      print("KabarDesaDetailDialog: Cleaned path: $cleanPath");
      print("KabarDesaDetailDialog: Final URL: $imageUrl");
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
          maxWidth: MediaQuery.of(context).size.width * 0.9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan judul dan tombol tutup
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFF4B9560),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Detail Kabar Desa',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content dalam scrollable view
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar jika ada
                    if (kabarDesa.gambar.isNotEmpty)
                      ClipRRect(
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/placeholder.png',
                          image: imageUrl,
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                          imageErrorBuilder: (context, error, stackTrace) {
                            print("KabarDesaDetailDialog: Error loading image: $error for URL: $imageUrl");
                            return Container(
                              height: 200,
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
  
                    // Judul
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            kabarDesa.judul,
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4B9560),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Tanggal
                          Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 16, color: Color(0xFF77A88B)),
                              const SizedBox(width: 6),
                              Text(
                                formattedDate,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
  
                          const SizedBox(height: 16),
  
                          // Deskripsi lengkap
                          Text(
                            kabarDesa.deskripsi,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              color: Colors.black87,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}