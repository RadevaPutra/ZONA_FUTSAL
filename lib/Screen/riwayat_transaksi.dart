import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class RiwayatTransaksiPage extends StatelessWidget {
  const RiwayatTransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = AppData.recentBookings;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Riwayat Transaksi", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1F2E), 
              Color(0xFF0F3D2E), 
            ],
          ),
        ),
        child: SafeArea(
          child: transactions.isEmpty 
              ? const Center(child: Text("Belum ada riwayat transaksi", style: TextStyle(color: Colors.white70)))
              : ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final tx = transactions[index];
              final isSuccess = tx.status == "Aktif" || tx.status == "Berhasil";
              final statusText = tx.status == "Aktif" ? "Berhasil" : tx.status;
              final formattedDate = DateFormat('dd MMM yyyy, ').format(tx.date) + tx.startTime;
              final formattedPrice = tx.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E2738).withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: isSuccess 
                                  ? AppColors.accent.withOpacity(0.15) 
                                  : Colors.redAccent.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSuccess ? AppColors.accent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                                width: 2,
                              )
                            ),
                            child: Icon(
                              isSuccess ? Icons.sports_soccer : Icons.cancel_outlined, 
                              color: isSuccess ? AppColors.accent : Colors.redAccent,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Booking ${tx.field.type}",
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  formattedDate, 
                                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Rp $formattedPrice", 
                                  style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w800, fontSize: 15),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSuccess ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSuccess ? Colors.greenAccent.withOpacity(0.5) : Colors.redAccent.withOpacity(0.5),
                              )
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: isSuccess ? Colors.greenAccent : Colors.redAccent,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
