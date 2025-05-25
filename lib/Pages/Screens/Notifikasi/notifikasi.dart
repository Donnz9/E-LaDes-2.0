import 'dart:async';
import 'package:elades20/Models/notifikasi/notifikasi_model.dart';
import 'package:elades20/Pages/Widgets/snackbar.dart';
import 'package:elades20/Services/Notifikasi/notifikasi_service.dart';
import 'package:flutter/material.dart';

class Notifikasi extends StatefulWidget {
  final void Function(int) onNavigate;
  final dynamic user;
  const Notifikasi({super.key, required this.onNavigate, required this.user});

  @override
  State<Notifikasi> createState() => _NotifikasiState();
}

class _NotifikasiState extends State<Notifikasi> {
  List<NotifikasiModel> notifications = [];
  bool isLoading = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadNotifications();

    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _loadNotifications();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    try {
      final username = widget.user.nama ?? '';
      print('username: $username');
      final notifs = await NotifikasiService.getUnreadNotifications(username);
      print('Notifs fetched: ${notifs.length}');

      if (mounted) {
        setState(() {
          notifications = notifs;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
        Snackbar.show(context, "Gagal memuat notifikasi", isError: true);
        debugPrint('Gagal memuat notifikasi: ${e.toString()}');
      }
    }
  }

  Future<void> _markAsRead(int notificationId) async {
    final success = await NotifikasiService.markAsRead(notificationId);

    if (success && mounted) {
      setState(() {
        notifications.removeWhere((notif) => notif.id == notificationId);
      });
      Snackbar.show(context, "Notifikasi telah dibaca");
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Baru saja';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Colors.green;
      case 'tolak':
        return Colors.red;
      case 'diproses':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'selesai':
        return Icons.check_circle;
      case 'tolak':
        return Icons.cancel;
      case 'diproses':
        return Icons.hourglass_empty;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header tetap (fixed header)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Notifikasi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4B9560),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  if (notifications.isNotEmpty)
                    Text(
                      'Anda memiliki ${notifications.length} notifikasi baru',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
            ),

            // Konten yang dapat di-scroll
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadNotifications,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    if (isLoading)
                      const SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF4B9560)),
                          ),
                        ),
                      )
                    else if (notifications.isEmpty)
                      SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.notifications_off,
                                size: 80,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada notifikasi',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Semua notifikasi Anda sudah dibaca',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final notification = notifications[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                  border: Border.all(
                                    color: const Color(0xFF4B9560)
                                        .withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(12),
                                    onTap: () => _markAsRead(notification.id),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Header dengan icon status dan waktu
                                          Row(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                          notification
                                                              .statusBaru)
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Icon(
                                                  _getStatusIcon(
                                                      notification.statusBaru),
                                                  color: _getStatusColor(
                                                      notification.statusBaru),
                                                  size: 20,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Surat ${notification.kodeSurat}',
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFF4B9560),
                                                      ),
                                                    ),
                                                    Text(
                                                      _formatTime(notification
                                                          .tanggalNotifikasi),
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Status badge
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: _getStatusColor(
                                                      notification.statusBaru),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  notification.statusBaru
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          // Pesan notifikasi
                                          Text(
                                            notification.pesan,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              height: 1.4,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          // Info tambahan
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                size: 14,
                                                color: Colors.grey[600],
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                notification.nama,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                              const Spacer(),
                                              Text(
                                                'Ketuk untuk menandai sudah dibaca',
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.grey[500],
                                                  fontStyle: FontStyle.italic,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            childCount: notifications.length,
                          ),
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
