import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../services/payment_service.dart';
import '../services/notification_service.dart';
import 'home.dart';
import 'booking.dart';
import 'confirm.dart';

class PaymentScreen extends StatefulWidget {
  final Booking booking;
  const PaymentScreen({super.key, required this.booking});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'QRIS';

  void _sendToWhatsApp() async {
    final adminNumber = "6281933053869"; // Nomor admin diperbarui
    final message = "Halo Admin, saya telah melakukan pembayaran.\n\n"
        "Detail Booking:\n"
        "- Lapangan: ${widget.booking.field.name}\n"
        "- Jadwal: ${widget.booking.startTime}\n"
        "- Total: Rp ${widget.booking.totalPrice}";

    final url = "https://wa.me/$adminNumber?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(url);
    
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tidak bisa membuka WhatsApp")),
        );
      }
    }
  }

  void _processPayment() {
    try {
      // 1. Tampilkan Notifikasi (Fire and Forget)
      NotificationService().showNotification(
        "Pembayaran Berhasil! ⚽", 
        "Booking ${widget.booking.field.name} berhasil dikonfirmasi."
      );
      
      // 2. Navigasi ke Halaman Konfirmasi/Tiket
      // Menggunakan push agar lebih stabil dan bisa kembali jika diperlukan
      Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ConfirmScreen(booking: widget.booking))
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Terjadi kesalahan: $e")),
      );
    }
  }

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
                  _sectionLabel("Ringkasan Pesanan"),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2623), 
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        _summaryRow("Lapangan", widget.booking.field.name),
                        _summaryRow("Tipe", widget.booking.subField),
                        _summaryRow("Jadwal", "${widget.booking.startTime} - ${widget.booking.endTime}"),
                        _summaryRow("Durasi", "${widget.booking.durationHours} Jam"),
                        if (widget.booking.discountAmount > 0) ...[
                          const Divider(color: Colors.white24, height: 16),
                          _summaryRow(
                            "Subtotal",
                            "Rp ${(widget.booking.totalPrice + widget.booking.discountAmount).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                          ),
                          _summaryRow(
                            "Voucher ${widget.booking.voucherCode ?? ''}",
                            "- Rp ${widget.booking.discountAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
                            isDiscount: true,
                          ),
                        ],
                        const Divider(color: Colors.white24, height: 24),
                        _summaryRow("Total Bayar", "Rp ${widget.booking.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}", isTotal: true),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),
                  _sectionLabel("Metode Pembayaran"),
                  const SizedBox(height: 12),
                  _paymentOption("QRIS", Icons.qr_code_scanner_rounded, detail: "SCAN_BCA_7670752148"),
                  _paymentOption("Gopay", Icons.account_balance_wallet_rounded, detail: "70001081923457465"),
                  
                  const SizedBox(height: 24),
                  _sectionLabel("Bank Transfer"),
                  const SizedBox(height: 12),
                  _paymentOption("Bank BCA", Icons.account_balance_rounded, detail: "7670752148"),
                  _paymentOption("Bank BNI", Icons.account_balance_rounded, detail: "0987654321"),
                  _paymentOption("Bank Mandiri", Icons.account_balance_rounded, detail: "1234567890"),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
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
                onPressed: _processPayment,
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
                    onPressed: _sendToWhatsApp, 
                    icon: const Icon(Icons.send, color: AppColors.darkGreen),
                    label: const Text("Kirim Bukti ke WA", style: TextStyle(color: AppColors.darkGreen, fontSize: 12)),
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

  Widget _paymentOption(String title, IconData icon, {String? detail}) {
    bool isSelected = selectedMethod == title;
    return GestureDetector(
      onTap: () => setState(() => selectedMethod = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.08) : const Color(0xFF1E2623),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.white.withOpacity(0.05),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ] : [],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.accent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: isSelected ? AppColors.accent : Colors.white70, size: 20),
                ),
                const SizedBox(width: 16),
                Text(
                  title, 
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 15,
                  )
                ),
                const Spacer(),
                if (isSelected) 
                  const Icon(Icons.check_circle, color: AppColors.accent, size: 22)
                else
                  Icon(Icons.circle_outlined, color: Colors.white.withOpacity(0.1), size: 20),
              ],
            ),
            if (isSelected && detail != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accent, // Latar belakang hijau terang
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    if (title == "QRIS")
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: QrImageView(
                              data: detail,
                              version: QrVersions.auto,
                              size: 160.0,
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text("Scan QRIS untuk pembayaran instan", 
                            style: TextStyle(color: Colors.black, fontSize: 11, fontWeight: FontWeight.bold)),
                        ],
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title == "Gopay" ? "Nomor HP / ID" : "Nomor Rekening", 
                                style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              const SizedBox(height: 6),
                              Text(
                                detail, 
                                style: const TextStyle(
                                  color: Colors.black, // Teks HITAM sesuai permintaan
                                  fontWeight: FontWeight.w900, 
                                  fontSize: 20,
                                  letterSpacing: 1.2,
                                )
                              ),
                            ],
                          ),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("$title berhasil disalin!"),
                                    backgroundColor: AppColors.darkGreen,
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(Icons.copy_all_rounded, color: Colors.black, size: 22),
                              ),
                            ),
                          )
                        ],
                      ),
                  ],
                ),
              ),
            ]
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
        color: AppColors.accent,
        fontSize: 12, 
        fontWeight: FontWeight.w900, 
        letterSpacing: 1.5,
      )
    ),
  );

  Widget _summaryRow(String label, String value, {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label, 
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            )
          ),
          Text(
            value, 
            style: TextStyle(
              color: isDiscount ? const Color(0xFF4ADE80) : isTotal ? AppColors.accent : Colors.white, 
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.bold,
              fontSize: isTotal ? 18 : 14,
            )
          ),
        ],
      ),
    );
  }
}
