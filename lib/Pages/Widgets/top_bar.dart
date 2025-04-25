import 'package:elades20/Models/user_model.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final VoidCallback onNotifTap;
  final UserModel user;

  TopBar({super.key, required this.onProfileTap, required this.onNotifTap, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onProfileTap,
                child: const CircleAvatar(
                  radius: 20,
                  backgroundColor: Color(0xFF7A9E7A),
                  child: Icon(Icons.person, color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hai!", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                  Text(user.nama, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
    );
  }
}
