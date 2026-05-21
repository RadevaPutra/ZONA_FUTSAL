import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/voucher_model.dart';
import '../Theme/app_theme.dart';

class VoucherScreen extends StatefulWidget {
  final int durationHours;
  final int totalPrice;
  final Voucher? selectedVoucher;

  const VoucherScreen({
    super.key,
    required this.durationHours,
    required this.totalPrice,
    this.selectedVoucher,
  });

  @override
  State<VoucherScreen> createState() => _VoucherScreenState();
}

class _VoucherScreenState extends State<VoucherScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _codeCtrl = TextEditingController();
  Voucher? _selected;
  String? _errorMsg;
  late AnimationController _shakeCtrl;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedVoucher;
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  void _applyCode() {
    final code = _codeCtrl.text.trim();
    if (code.isEmpty) {
      setState(() => _errorMsg = 'Masukkan kode voucher terlebih dahulu');
      _shakeCtrl.forward(from: 0);
      return;
    }

    final voucher = VoucherData.findByCode(code);
    if (voucher == null) {
      setState(() => _errorMsg = 'Kode voucher tidak ditemukan');
      _shakeCtrl.forward(from: 0);
      return;
    }
    if (voucher.isExpired) {
      setState(() => _errorMsg = 'Voucher sudah kedaluwarsa');
      _shakeCtrl.forward(from: 0);
      return;
    }
    if (widget.durationHours < voucher.minDurationHours) {
      setState(() => _errorMsg =
          'Voucher ini hanya berlaku untuk booking min. ${voucher.minDurationHours} jam');
      _shakeCtrl.forward(from: 0);
      return;
    }

    setState(() {
      _selected = voucher;
      _errorMsg = null;
    });
    _codeCtrl.clear();
    FocusScope.of(context).unfocus();
    _showVoucherApplied(voucher);
  }

  void _showVoucherApplied(Voucher voucher) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Text(voucher.iconEmoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Voucher ${voucher.code} berhasil diterapkan!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.darkGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatPrice(int price) {
    return NumberFormat('#,###', 'id_ID').format(price);
  }

  @override
  Widget build(BuildContext context) {
    final validVouchers = VoucherData.availableVouchers
        .where((v) => v.isValid)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: const Text('Pilih Voucher',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
        backgroundColor: AppColors.darkGreen,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          if (_selected != null)
            TextButton(
              onPressed: () => setState(() => _selected = null),
              child: const Text('Reset',
                  style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: Column(
        children: [
          // Banner syarat
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F3D2E), Color(0xFF1A5A3E)],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline_rounded,
                    color: AppColors.accent, size: 16),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Voucher hanya berlaku untuk booking lebih dari 2 jam',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input kode voucher
                  _buildCodeInput(),
                  const SizedBox(height: 20),

                  // Voucher tersedia
                  const Text('VOUCHER TERSEDIA',
                      style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                          letterSpacing: 1.2)),
                  const SizedBox(height: 12),

                  if (validVouchers.isEmpty)
                    _buildEmptyState()
                  else
                    ...validVouchers.map((v) => _buildVoucherCard(v)),
                ],
              ),
            ),
          ),

          // Bottom bar konfirmasi
          if (_selected != null) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildCodeInput() {
    return AnimatedBuilder(
      animation: _shakeAnim,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeCtrl.isAnimating ? _shakeAnim.value * (_shakeCtrl.value < 0.5 ? 1 : -1) : 0, 0),
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _errorMsg != null ? Colors.red.shade300 : AppColors.border,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Punya Kode Voucher?',
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Masukkan kode voucher',
                      hintStyle: TextStyle(
                          color: AppColors.textSecondary.withOpacity(0.6),
                          fontSize: 13),
                      prefixIcon: const Icon(Icons.confirmation_number_outlined,
                          color: AppColors.textSecondary, size: 20),
                      filled: true,
                      fillColor: AppColors.bg,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                    ),
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1),
                    onSubmitted: (_) => _applyCode(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.darkGreen,
                    foregroundColor: AppColors.accent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text('Pakai',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            if (_errorMsg != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.error_outline_rounded,
                      color: Colors.red, size: 14),
                  const SizedBox(width: 4),
                  Text(_errorMsg!,
                      style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherCard(Voucher voucher) {
    final isSelected = _selected?.code == voucher.code;
    final isEligible = widget.durationHours >= voucher.minDurationHours;
    final discount = voucher.calculateDiscount(widget.totalPrice);
    final daysLeft =
        voucher.expiredAt.difference(DateTime.now()).inDays;

    return GestureDetector(
      onTap: isEligible
          ? () {
              setState(() {
                _selected = isSelected ? null : voucher;
                _errorMsg = null;
              });
            }
          : () {
              setState(() => _errorMsg =
                  'Booking Anda kurang dari ${voucher.minDurationHours} jam');
              _shakeCtrl.forward(from: 0);
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : isEligible
                    ? AppColors.border
                    : AppColors.border.withOpacity(0.4),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Opacity(
          opacity: isEligible ? 1.0 : 0.5,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Kiri – strip warna + emoji
                Container(
                  width: 72,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.darkGreen
                        : AppColors.darkGreen.withOpacity(0.08),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(voucher.iconEmoji,
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.accent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          voucher.discountLabel,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: isSelected
                                ? AppColors.darkGreen
                                : AppColors.darkGreen,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Perforasi
                _buildPerforation(isSelected),

                // Kanan – detail voucher
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                voucher.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                    color: AppColors.textPrimary),
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.accent, size: 20),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          voucher.description,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _chip(
                              Icons.schedule_rounded,
                              'Min. ${voucher.minDurationHours} jam',
                              isSelected
                                  ? AppColors.accent.withOpacity(0.15)
                                  : AppColors.cardBg,
                            ),
                            const SizedBox(width: 6),
                            _chip(
                              Icons.calendar_today_rounded,
                              daysLeft <= 3
                                  ? 'Berakhir $daysLeft hari lagi'
                                  : 'Berakhir ${DateFormat('dd MMM').format(voucher.expiredAt)}',
                              daysLeft <= 3
                                  ? Colors.red.shade50
                                  : AppColors.cardBg,
                              textColor: daysLeft <= 3
                                  ? Colors.red
                                  : AppColors.textSecondary,
                            ),
                          ],
                        ),
                        if (isSelected && discount > 0) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: AppColors.darkGreen,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Hemat Rp ${_formatPrice(discount)}',
                              style: const TextStyle(
                                  color: AppColors.accent,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 12),
                            ),
                          ),
                        ],
                        if (!isEligible) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.lock_outline_rounded,
                                  size: 11, color: Colors.orange),
                              const SizedBox(width: 4),
                              Text(
                                'Tambah jam booking untuk unlock',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.orange.shade700),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerforation(bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        8,
        (i) => Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.accent.withOpacity(0.3)
                : AppColors.border,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _chip(IconData icon, String label, Color bg,
      {Color textColor = AppColors.textSecondary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
          color: bg, borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: textColor),
          const SizedBox(width: 3),
          Text(label, style: TextStyle(fontSize: 10, color: textColor)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text('🎟️', style: TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            const Text('Belum ada voucher tersedia',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            const Text('Pantau terus promo dari Zona Futsal!',
                style: TextStyle(
                    fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final discount = _selected!.calculateDiscount(widget.totalPrice);
    final finalPrice = widget.totalPrice - discount;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.darkGreen,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total sebelum diskon',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                Text('Rp ${_formatPrice(widget.totalPrice)}',
                    style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(_selected!.iconEmoji,
                        style: const TextStyle(fontSize: 14)),
                    const SizedBox(width: 6),
                    Text(_selected!.code,
                        style: const TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                Text('- Rp ${_formatPrice(discount)}',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(color: Colors.white24, height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Bayar',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
                Text('Rp ${_formatPrice(finalPrice)}',
                    style: const TextStyle(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w900,
                        fontSize: 18)),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context, _selected),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.darkGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: const Text('Gunakan Voucher Ini',
                    style: TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
