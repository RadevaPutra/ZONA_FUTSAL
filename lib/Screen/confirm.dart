import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'home.dart';

class ConfirmScreen extends StatefulWidget {
  final Booking booking;
  const ConfirmScreen({super.key, required this.booking});

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> with TickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnim = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _scaleCtrl.forward().then((_) {
      if (mounted) {
        _showSuccessPopup();
      }
    });
  }

  void _showSuccessPopup() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Pembayaran Sukses!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFF0F3D2E)),
            ),
            const SizedBox(height: 8),
            const Text(
              "E-Ticket Anda telah diterbitkan. Silakan kirim detail booking ke WhatsApp Admin.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: const Color(0xFF0F3D2E),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  elevation: 0,
                ),
                child: const Text("Lihat E-Ticket", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    super.dispose();
  }
  Future<void> _sendTicketToWhatsApp() async {
    const String nomorAdmin = "6281933053869"; 
    final formatter = NumberFormat('#,###', 'id_ID');
    final String formattedPrice = formatter.format(widget.booking.totalPrice);
    final bool hasDiscount = widget.booking.discountAmount > 0;
    final String formattedDiscount = formatter.format(widget.booking.discountAmount);
    final String formattedSubtotal = formatter.format(
      widget.booking.totalPrice + widget.booking.discountAmount,
    );

    final String message = '''
⚽ *E-TICKET FUTSALKU* ⚽
------------------------------------------
Kode Booking : ${widget.booking.bookingCode}
Lapangan     : ${widget.booking.field.name} (${widget.booking.subField})
Tanggal      : ${DateFormat('EEEE, dd MMM yyyy').format(widget.booking.date)}
Waktu        : ${widget.booking.startTime} - ${widget.booking.endTime}
Durasi       : ${widget.booking.durationHours} Jam${hasDiscount ? '''
------------------------------------------
Subtotal     : Rp $formattedSubtotal
Voucher      : ${widget.booking.voucherCode ?? '-'} (-Rp $formattedDiscount)''' : ''}
------------------------------------------
Total Bayar  : Rp $formattedPrice
Status       : LUNAS ✅
------------------------------------------
Simpan tiket ini dan Terima kasih telah berolahraga!''';

    final Uri whatsappUri = Uri.parse(
      "https://wa.me/$nomorAdmin?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw "Tidak dapat membuka WhatsApp";
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Gagal membuka WhatsApp. Pastikan aplikasi terpasang."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F3D2E), Color(0xFF1A1F2E)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: _scaleAnim,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 35),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _ticketRow(
                        label: 'Tempat & Lapangan',
                        value: '${widget.booking.field.name} (${widget.booking.subField})',
                      ),
                      const SizedBox(height: 12),
                      _ticketRow(
                        label: 'Waktu Sewa',
                        value: '${widget.booking.startTime} - ${widget.booking.endTime}',
                      ),
                      const SizedBox(height: 12),
                      _ticketRow(
                        label: 'Tanggal',
                        value: DateFormat('EEEE, dd MMM yyyy').format(widget.booking.date),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(thickness: 1, color: Color(0xFFEEEEEE)),
                      ),
                      const Text(
                        "Transfer Ke Virtual Account",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.account_balance_wallet_rounded, 
                                size: 18, color: AppColors.darkGreen),
                            const SizedBox(width: 10),
                            const Text(
                              "76707821223",
                              style: TextStyle(
                                  fontWeight: FontWeight.w900, 
                                  fontSize: 18, 
                                  letterSpacing: 1.5,
                                  color: AppColors.textPrimary),
                            ),
                            const SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Nomor VA disalin!")),
                                );
                              },
                              child: const Icon(Icons.copy_rounded, size: 16, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      QrImageView(
                        data: widget.booking.bookingCode,
                        version: QrVersions.auto,
                        size: 160.0,
                        gapless: false,
                        foregroundColor: const Color(0xFF0F3D2E),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.booking.bookingCode,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          letterSpacing: 4,
                          color: Color(0xFF0F3D2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // SATU TOMBOL UTAMA (MINIMALIS)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _sendTicketToWhatsApp,
                        icon: const Icon(Icons.share_rounded, size: 20),
                        label: const Text("BAGIKAN TIKET KE WHATSAPP"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: const Color(0xFF0F3D2E),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                        (route) => false,
                      ),
                      child: const Text(
                        "Kembali ke Beranda",
                        style: TextStyle(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _ticketRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Color(0xFF1A1F2E),
          ),
        ),
      ],
    );
  }
}
