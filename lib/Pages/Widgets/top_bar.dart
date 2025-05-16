import 'package:elades20/Models/user_model.dart';
import 'package:elades20/Services/config.dart'; // Import AppConfig
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotifTap;
  final UserModel user;

  const TopBar({
    super.key,
    required this.onProfileTap,
    required this.onNotifTap,
    required this.user,
  });

  String? getFormattedProfileImageUrl() {
    if (user.profileImage == null || user.profileImage!.isEmpty) {
      return null;
    }
    String filename = user.profileImage!.split('/').last;
    String encodedFilename = Uri.encodeComponent(filename);
    // String formattedUrl = "${AppConfig.uploads}/uploads/foto_profile/$encodedFilename";
    // debugPrint('TopBar profile image URL: $formattedUrl');
    // return formattedUrl;
    String formattedUrl =
        "${AppConfig.uploads}/uploads/foto_profile/$encodedFilename";
    debugPrint('TopBar profile image URL: $formattedUrl');
    return formattedUrl;
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = getFormattedProfileImageUrl();

    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4.0,
                offset: Offset(0, 2), // Shadow slightly below the container
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onProfileTap,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: const Color(0xFF7A9E7A),
                        child: ClipOval(
                          child: imageUrl != null
                              ? FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/placeholder_profil.png',
                                  image: imageUrl,
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                  imageErrorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.person, color: Colors.white);
                                  },
                                )
                              : const Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Hai!", 
                          style: TextStyle(
                            fontSize: 14, 
                            fontWeight: FontWeight.w400
                          )
                        ),
                        Text(
                          user.nama, 
                          style: const TextStyle(
                            fontSize: 16, 
                            fontWeight: FontWeight.bold
                          )
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: onNotifTap,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}