import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/voucher_model.dart';
import '../Theme/app_theme.dart';
import 'payment.dart';
import 'voucher_screen.dart';

class BookingScreen extends StatefulWidget {
  final Field field;

  const BookingScreen({super.key, required this.field});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 0;
  final Set<String> _selectedTimes = {};
  String _selectedSubField = 'Lapangan A';
  Voucher? _appliedVoucher;

  static const List<_DateItem> _dates = [
    _DateItem(day: 'Sen', num: '03'),
    _DateItem(day: 'Sel', num: '04'),
    _DateItem(day: 'Rab', num: '05'),
    _DateItem(day: 'Kam', num: '06'),
    _DateItem(day: 'Jum', num: '07'),
    _DateItem(day: 'Sab', num: '08'),
  ];

  /// Durasi booking berdasarkan slot yang dipilih (tiap slot = 2 jam)
  int get _durationHours => _selectedTimes.length * 2;

  int get _subtotal => widget.field.pricePerHour * _durationHours;

  int get _discountAmount {
    if (_appliedVoucher == null) return 0;
    if (_durationHours < _appliedVoucher!.minDurationHours) return 0;
    return _appliedVoucher!.calculateDiscount(_subtotal);
  }

  int get _totalPrice => _subtotal - _discountAmount;

  String _generateBookingCode() {
    final now = DateTime.now();
    return 'FTL-${now.millisecondsSinceEpoch.toString().substring(7)}';
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }

  String get _startTime {
    if (_selectedTimes.isEmpty) return '--:--';
    final sorted = _sortedSlots();
    return sorted.first.split(' - ')[0];
  }

  String get _endTime {
    if (_selectedTimes.isEmpty) return '--:--';
    final sorted = _sortedSlots();
    final parts = sorted.last.split(' - ');
    return parts.length > 1 ? parts[1] : '--:--';
  }

  List<String> _sortedSlots() {
    final list = _selectedTimes.toList();
    list.sort((a, b) => a.compareTo(b));
    return list;
  }

  Future<void> _openVoucherScreen() async {
    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih waktu booking terlebih dahulu'),
          backgroundColor: AppColors.darkGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    final result = await Navigator.push<Voucher?>(
      context,
      MaterialPageRoute(
        builder: (_) => VoucherScreen(
          durationHours: _durationHours,
          totalPrice: _subtotal,
          selectedVoucher: _appliedVoucher,
        ),
      ),
    );

    setState(() {
      _appliedVoucher = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF0F3D2E), Color(0xFF1A5A3E)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Reservasi Lapangan',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: Colors.white)),
                      const SizedBox(height: 4),
                      Text(
                        '${widget.field.name} · ${widget.field.type}',
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Pilih Lapangan"),
                  const SizedBox(height: 12),
                  Row(
                    children: ['Lapangan A', 'Lapangan B', 'Lapangan C']
                        .map((sub) {
                      bool isSelected = _selectedSubField == sub;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedSubField = sub),
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 4),
                            padding:
                                const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.accent
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : AppColors.border),
                            ),
                            child: Center(
                              child: Text(
                                sub,
                                style: TextStyle(
                                  color: isSelected
                                      ? AppColors.darkGreen
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 22),
                  _sectionLabel('Pilih Tanggal'),
                  const SizedBox(height: 10),
                  _buildDateList(),
                  const SizedBox(height: 22),

                  // Header waktu + badge durasi
                  Row(
                    children: [
                      Expanded(child: _sectionLabel('Pilih Waktu')),
                      if (_selectedTimes.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreen,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '$_durationHours Jam Dipilih',
                            style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  // Info multi-select
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.touch_app_rounded,
                            size: 14, color: AppColors.darkGreen),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            'Pilih beberapa slot untuk booking lebih dari 2 jam',
                            style: TextStyle(
                                fontSize: 11,
                                color: AppColors.darkGreen,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildTimeGrid(),
                  const SizedBox(height: 22),

                  // Voucher Section
                  _buildVoucherSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomSummary(),
    );
  }

  Widget _buildVoucherSection() {
    final bool hasVoucher = _appliedVoucher != null;
    return GestureDetector(
      onTap: _openVoucherScreen,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasVoucher ? AppColors.darkGreen : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasVoucher ? AppColors.accent : AppColors.border,
            width: hasVoucher ? 1.5 : 1,
          ),
          boxShadow: hasVoucher
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: hasVoucher
                    ? AppColors.accent.withOpacity(0.15)
                    : AppColors.cardBg,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  hasVoucher ? _appliedVoucher!.iconEmoji : '🎟️',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: hasVoucher
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _appliedVoucher!.title,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Hemat Rp ${_formatPrice(_discountAmount)}',
                          style: const TextStyle(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pakai Voucher',
                          style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _selectedTimes.isEmpty
                              ? 'Pilih waktu dulu untuk pakai voucher'
                              : _durationHours < 2
                                  ? 'Tambah slot untuk unlock voucher'
                                  : 'Pilih voucher & hemat lebih banyak!',
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
            ),
            Icon(
              hasVoucher
                  ? Icons.close_rounded
                  : Icons.chevron_right_rounded,
              color:
                  hasVoucher ? AppColors.accent : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateList() {
    return SizedBox(
      height: 70,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _dates.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final isSelected = _selectedDateIndex == i;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDateIndex = i;
                _selectedTimes.clear();
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color:
                    isSelected ? AppColors.darkGreen : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: isSelected
                        ? AppColors.darkGreen
                        : AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_dates[i].day,
                      style: TextStyle(
                          fontSize: 10,
                          color: isSelected
                              ? Colors.white60
                              : AppColors.textSecondary)),
                  Text(_dates[i].num,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? AppColors.accent
                              : AppColors.textPrimary)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2.8,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12),
      itemCount: AppData.timeSlots.length,
      itemBuilder: (_, i) {
        final slot = AppData.timeSlots[i];
        final isTaken = AppData.bookedSlots.contains(slot);
        final isSelected = _selectedTimes.contains(slot);
        return GestureDetector(
          onTap: isTaken
              ? null
              : () {
                  setState(() {
                    if (_selectedTimes.contains(slot)) {
                      _selectedTimes.remove(slot);
                      // Reset voucher jika durasi tidak memenuhi syarat
                      if (_appliedVoucher != null &&
                          _durationHours <
                              _appliedVoucher!.minDurationHours) {
                        _appliedVoucher = null;
                      }
                    } else {
                      _selectedTimes.add(slot);
                    }
                  });
                },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isTaken
                  ? AppColors.cardBg
                  : isSelected
                      ? AppColors.darkGreen
                      : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isSelected
                      ? AppColors.darkGreen
                      : AppColors.border),
            ),
            child: Center(
              child: Text(slot,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isTaken
                          ? Colors.grey
                          : isSelected
                              ? AppColors.accent
                              : AppColors.textPrimary)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomSummary() {
    if (_selectedTimes.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
            // Ringkasan harga
            _summaryRow(
                'Harga (${_durationHours} jam)',
                'Rp ${_formatPrice(_subtotal)}'),
            if (_discountAmount > 0)
              _summaryRow(
                'Diskon ${_appliedVoucher!.code}',
                '- Rp ${_formatPrice(_discountAmount)}',
                isDiscount: true,
              ),
            if (_discountAmount > 0)
              const Divider(height: 16, color: AppColors.border),
            _summaryRow(
              'Total Bayar',
              'Rp ${_formatPrice(_totalPrice)}',
              isTotal: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  final booking = Booking(
                    bookingCode: _generateBookingCode(),
                    field: widget.field,
                    subField: _selectedSubField,
                    date: DateTime.now(),
                    startTime: _startTime,
                    endTime: _endTime,
                    durationHours: _durationHours,
                    totalPrice: _totalPrice,
                    discountAmount: _discountAmount,
                    voucherCode: _appliedVoucher?.code,
                  );
                  AppData.recentBookings.insert(0, booking);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => PaymentScreen(booking: booking)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkGreen,
                  foregroundColor: AppColors.accent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Lanjutkan Pembayaran →',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) =>
      Text(text.toUpperCase(), style: AppTextStyles.caption);

  Widget _summaryRow(String label, String value,
      {bool isTotal = false, bool isDiscount = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 13,
                  color: isTotal
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                  fontWeight:
                      isTotal ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontSize: isTotal ? 15 : 13,
                  fontWeight: FontWeight.w700,
                  color: isDiscount
                      ? Colors.green.shade600
                      : isTotal
                          ? AppColors.darkGreen
                          : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _DateItem {
  final String day, num;
  const _DateItem({required this.day, required this.num});
}
