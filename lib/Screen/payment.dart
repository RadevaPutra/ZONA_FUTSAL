import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'home.dart';
import 'booking.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;
  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'QRIS';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text("Pembayaran", style: TextStyle(color: Colors.white, fontSize: 16)),
        backgroundColor: AppColors.darkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BAGIAN 1: DETAIL TRANSAKSI
                  _sectionLabel("Ringkasan Pesanan"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2623), // Warna solid (tidak transparan) agar teks di atasnya tajam
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        _summaryRow("Lapangan", widget.booking.field.name),
                        _summaryRow("Tipe", widget.booking.subField),
                        _summaryRow("Jadwal", "${widget.booking.startTime} - ${widget.booking.endTime}"),
                        const Divider(color: Colors.white24, height: 24),
                        _summaryRow("Total Bayar", "Rp ${widget.booking.totalPrice}", isTotal: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // BAGIAN 2: METODE PEMBAYARAN
                  _sectionLabel("Metode Pembayaran"),
                  const SizedBox(height: 12),
                  _paymentOption("QRIS", Icons.qr_code_scanner_rounded),
                  _paymentOption("Gopay", Icons.account_balance_wallet_rounded),
                  _paymentOption("Virtual Account", Icons.vibration_rounded),
                  
                  const SizedBox(height: 16),
                  _sectionLabel("Bank Transfer"),
                  const SizedBox(height: 8),
                  _paymentOption("Bank BCA", Icons.account_balance_rounded),
                  _paymentOption("Bank BNI", Icons.account_balance_rounded),
                  _paymentOption("Bank Mandiri", Icons.account_balance_rounded),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // BAGIAN 3: TOMBOL AKSI
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: const Color(0xFF0F3D2E),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white24),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Batalkan", style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSuccessPopup(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text("Konfirmasi Bayar", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccessPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text("Transaksi telah berhasil dilakukan", 
                textAlign: TextAlign.center, 
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textPrimary)),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {}, 
                    icon: const Icon(Icons.share, color: AppColors.darkGreen),
                    label: const Text("Share", style: TextStyle(color: AppColors.darkGreen)),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: const BorderSide(color: AppColors.darkGreen),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (_) => const HomeScreen()), (r) => false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Beranda", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _paymentOption(String title, IconData icon) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withOpacity(0.2) : const Color(0xFF1E2623),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white.withOpacity(0.1),
            width: 1.5
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.accent : Colors.white, size: 22),
            const SizedBox(width: 16),
            Text(
              title, 
              style: const TextStyle(
                color: Colors.white, // Selalu Putih Solid
                fontWeight: FontWeight.bold,
                fontSize: 14,
              )
            ),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: AppColors.accent, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 8),
    child: Text(
      text.toUpperCase(), 
      style: const TextStyle(
        color: AppColors.accent, // Gunakan warna hijau terang (Aksen)
        fontSize: 12, 
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.5,
      )
    ),
  );

  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(
              color: Colors.white, // Putih solid, bukan transparan
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
          ),
          Text(
            value, 
            style: TextStyle(
              color: isTotal ? AppColors.accent : Colors.white, 
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold, // Dipertebal
              fontSize: isTotal ? 18 : 14, // Ukuran diperbesar sedikit
            )
          ),
        ],
      ),
    );
  }
}
