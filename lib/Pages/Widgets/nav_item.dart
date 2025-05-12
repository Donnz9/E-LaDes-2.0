import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final Function(int) onTap;
  final Color activeColor;
  final Color inactiveColor;

  const NavItem({
    super.key,
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onTap,
    this.activeColor = const Color(0xFF6A9F73),
    this.inactiveColor = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        color: Colors.transparent,
        constraints: const BoxConstraints(minWidth: 60),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? activeColor.withOpacity(0.1) : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: AnimatedScale(
                duration: const Duration(milliseconds: 250),
                scale: isSelected ? 1.1 : 1.0,
                child: Icon(
                  icon,
                  color: isSelected ? activeColor : inactiveColor,
                  size: 24,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 2),
                height: 2,
                width: 20,
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ShadowedBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final Color shadowColor;
  final double shadowElevation;
  
  const ShadowedBottomNavigationBar({
    super.key, 
    required this.selectedIndex, 
    required this.onItemTapped,
    this.shadowColor = Colors.black26,
    this.shadowElevation = 8.0,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: const Offset(0, -2), // Shadow arah ke atas
            blurRadius: shadowElevation,
            spreadRadius: 0,
          ),
        ],
      ),
      child: BottomAppBar(
        color: Colors.transparent, // Transparan karena container sudah berwarna
        elevation: 0, // Hilangkan elevasi default
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: NavItem(
                  icon: Icons.file_copy,
                  label: 'Pengajuan',
                  index: 0,
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                ),
              ),
              Expanded(
                child: NavItem(
                  icon: Icons.history,
                  label: 'Riwayat',
                  index: 1,
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                ),
              ),
              const SizedBox(width: 40),
              Expanded(
                child: NavItem(
                  icon: Icons.report,
                  label: 'Pengaduan',
                  index: 2,
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                ),
              ),
              Expanded(
                child: NavItem(
                  icon: Icons.article,
                  label: 'Berita',
                  index: 4,
                  selectedIndex: selectedIndex,
                  onTap: onItemTapped,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}