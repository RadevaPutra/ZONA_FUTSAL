import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NotifikasiPage extends StatefulWidget {
  const NotifikasiPage({super.key});

  @override
  State<NotifikasiPage> createState() =>
      _NotifikasiPageState();
}

class _NotifikasiPageState
    extends State<NotifikasiPage> {

  // Daftar data notifikasi awal
  List<Map<String, dynamic>> notif = [
    {
      "title": "Booking Confirmed",
      "desc": "Lapangan Court A berhasil dipesan",
      "time": "2m ago",
      "icon": Icons.check_circle,
    },
    {
      "title": "Match Reminder",
      "desc": "Pertandingan dimulai 1 jam lagi",
      "time": "1h ago",
      "icon": Icons.access_time,
    },
    {
      "title": "Promo Baru",
      "desc": "Diskon 20% booking malam ini",
      "time": "3h ago",
      "icon": Icons.local_offer,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg, 

      appBar: AppBar(
        title: const Text("Notifications"),
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        actions: [
          // Tombol untuk menghapus semua notifikasi
          TextButton(
            onPressed: () {
              setState(() {
                notif.clear();
              });
            },
            child: const Text(
              "Clear",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),

      // Menampilkan pesan jika tidak ada notifikasi, atau daftar jika ada
      body: notif.isEmpty
          ? const Center(
        child: Text(
          "Belum ada notifikasi",
          style: TextStyle(fontSize: 18, color: Colors.white70),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notif.length,
        itemBuilder: (context, index) {
          final item = notif[index];

          return Container(
            margin: const EdgeInsets.only(
              bottom: 12,
            ),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(16),
            ),
            child: Row(
              children: [

                CircleAvatar(
                  backgroundColor:
                  Colors.green.shade100,
                  child: Icon(
                    item["icon"],
                    color:
                    AppColors.darkGreen,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [

                      Text(
                        item["title"],
                        style:
                        const TextStyle(
                          fontWeight:
                          FontWeight.bold,
                        ),
                      ),

                      const SizedBox(
                          height: 4),

                      Text(item["desc"]),

                      const SizedBox(
                          height: 4),

                      Text(
                        item["time"],
                        style:
                        const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),

      // Tombol tambah untuk mensimulasikan notifikasi baru
      floatingActionButton:
      FloatingActionButton(
        backgroundColor:
        AppColors.darkGreen,
        onPressed: () {
          setState(() {
            notif.insert(0, {
              "title": "Pesan Baru",
              "desc":
              "Admin mengirim promo terbaru",
              "time": "now",
              "icon": Icons.message,
            });
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
