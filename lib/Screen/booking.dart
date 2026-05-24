import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/voucher_model.dart';
import '../Theme/app_theme.dart';
import 'payment.dart';
import 'voucher_screen.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  final Field field;
  const BookingScreen({super.key, required this.field});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 0;
  final Set<String> _selectedTimes = {};
  String _selectedSubField = 'Lapangan 1';
  Voucher? _appliedVoucher;
  List<_DateItem> _dates = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dates = List.generate(6, (index) {
      final date = now.add(Duration(days: index));
      return _DateItem(
        day: DateFormat('EEE').format(date),
        num: DateFormat('dd').format(date),
        fullDate: date,
      );
    });
  }

  String get selectedDateKey => DateFormat('yyyy-MM-dd').format(_dates[_selectedDateIndex].fullDate);

  int get _durationHours => _selectedTimes.length * 2;
  int get _subtotal => widget.field.pricePerHour * _durationHours;
  int get _discountAmount {
    if (_appliedVoucher == null || _durationHours < _appliedVoucher!.minDurationHours) return 0;
    return _appliedVoucher!.calculateDiscount(_subtotal);
  }
  int get _totalPrice => _subtotal - _discountAmount;

  String _generateBookingCode() => 'FTL-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';

  String _formatPrice(int price) => price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');

  String get _startTime => _selectedTimes.isEmpty ? '--:--' : _sortedSlots().first.split(' - ')[0];
  String get _endTime => _selectedTimes.isEmpty ? '--:--' : _sortedSlots().last.split(' - ').last;

  List<String> _sortedSlots() => _selectedTimes.toList()..sort();

  Future<void> _openVoucherScreen() async {
    if (_selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih waktu dulu!')));
      return;
    }
    final result = await Navigator.push<Voucher?>(
      context,
      MaterialPageRoute(builder: (_) => VoucherScreen(durationHours: _durationHours, totalPrice: _subtotal, selectedVoucher: _appliedVoucher)),
    );
    setState(() => _appliedVoucher = result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildHeader(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionLabel("Pilih Lapangan"),
                  _buildSubFieldSelector(),
                  const SizedBox(height: 22),
                  _sectionLabel('Pilih Tanggal'),
                  const SizedBox(height: 10),
                  _buildDateList(),
                  const SizedBox(height: 22),
                  _sectionLabel('Pilih Waktu'),
                  _buildTimeGrid(),
                  const SizedBox(height: 22),
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

  Widget _buildHeader() => SliverToBoxAdapter(
    child: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF0F3D2E), Color(0xFF1A5A3E)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(28), bottomRight: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white)),
              const SizedBox(height: 16),
              const Text('Reservasi Lapangan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
              Text('${widget.field.name} · ${widget.field.type}', style: TextStyle(color: Colors.white.withOpacity(0.5))),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _buildSubFieldSelector() => Row(
    children: ['Lapangan 1', 'Lapangan 2', 'Lapangan 3'].map((sub) {
      bool isSelected = _selectedSubField == sub;
      return Expanded(
        child: GestureDetector(
          onTap: () => setState(() { _selectedSubField = sub; _selectedTimes.clear(); }),
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: isSelected ? AppColors.accent : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.accent : AppColors.border)),
            child: Center(child: Text(sub, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? AppColors.darkGreen : AppColors.textPrimary))),
          ),
        ),
      );
    }).toList(),
  );

  Widget _buildDateList() => SizedBox(
    height: 70,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _dates.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final isSelected = _selectedDateIndex == i;
        return GestureDetector(
          onTap: () => setState(() { _selectedDateIndex = i; _selectedTimes.clear(); }),
          child: Container(
            width: 54,
            decoration: BoxDecoration(color: isSelected ? AppColors.darkGreen : Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: isSelected ? AppColors.darkGreen : AppColors.border)),
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_dates[i].day, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white60 : AppColors.textSecondary)),
              Text(_dates[i].num, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected ? AppColors.accent : AppColors.textPrimary)),
            ]),
          ),
        );
      },
    ),
  );

  Widget _buildTimeGrid() {
    final scheduleKey = "${selectedDateKey}_${widget.field.id}_$_selectedSubField";
    final bookedSlots = AppData.bookedSlotsByDate[scheduleKey] ?? [];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: AppData.timeSlots.length,
      itemBuilder: (_, i) {
        final slot = AppData.timeSlots[i];
        final isTaken = bookedSlots.contains(slot);
        final isSelected = _selectedTimes.contains(slot);
        return GestureDetector(
          onTap: isTaken ? null : () => setState(() { isSelected ? _selectedTimes.remove(slot) : _selectedTimes.add(slot); }),
          child: Container(
            decoration: BoxDecoration(color: isTaken ? Colors.grey.shade300 : isSelected ? AppColors.darkGreen : Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: isSelected ? AppColors.darkGreen : AppColors.border)),
            child: Center(child: Text(slot, style: TextStyle(fontWeight: FontWeight.w600, color: isTaken ? Colors.grey : isSelected ? AppColors.accent : AppColors.textPrimary))),
          ),
        );
      },
    );
  }

  Widget _buildVoucherSection() {
    final bool hasVoucher = _appliedVoucher != null;
    return GestureDetector(
      onTap: _openVoucherScreen,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: hasVoucher ? AppColors.darkGreen : Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: hasVoucher ? AppColors.accent : AppColors.border)),
        child: Row(children: [
          Text(hasVoucher ? _appliedVoucher!.iconEmoji : '🎟️', style: const TextStyle(fontSize: 20)),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(hasVoucher ? _appliedVoucher!.title : 'Pakai Voucher', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
            Text(hasVoucher ? 'Hemat Rp ${_formatPrice(_discountAmount)}' : 'Pilih voucher & hemat!', style: const TextStyle(fontSize: 11)),
          ])),
          Icon(Icons.chevron_right_rounded, color: hasVoucher ? AppColors.accent : Colors.grey),
        ]),
      ),
    );
  }

  Widget _buildBottomSummary() {
    if (_selectedTimes.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
        onPressed: () {
          final booking = Booking(bookingCode: _generateBookingCode(), username: AppData.currentUser, field: widget.field, subField: _selectedSubField, date: _dates[_selectedDateIndex].fullDate, startTime: _startTime, endTime: _endTime, durationHours: _durationHours, totalPrice: _totalPrice);
          AppData.recentBookings.insert(0, booking);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(booking: booking)));
        },
        child: const Text('Lanjutkan Pembayaran →', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text.toUpperCase(), style: AppTextStyles.caption);
}

class _DateItem {
  final String day, num;
  final DateTime fullDate;
  const _DateItem({required this.day, required this.num, required this.fullDate});
}