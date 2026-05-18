import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'payment.dart';

class BookingScreen extends StatefulWidget {
  final Field field;

  const BookingScreen({super.key, required this.field});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int _selectedDateIndex = 0;
  String? _selectedTime;
  String _selectedSubField = 'Lapangan A';

  static const List<_DateItem> _dates = [
    _DateItem(day: 'Sen', num: '03'),
    _DateItem(day: 'Sel', num: '04'),
    _DateItem(day: 'Rab', num: '05'),
    _DateItem(day: 'Kam', num: '06'),
    _DateItem(day: 'Jum', num: '07'),
    _DateItem(day: 'Sab', num: '08'),
  ];

  int get _totalPrice => widget.field.pricePerHour * 2;
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
    if (_selectedTime == null) return '--:--';
    return _selectedTime!.split(' - ')[0];
  }

  String get _endTime {
    if (_selectedTime == null) return '--:--';
    final parts = _selectedTime!.split(' - ');
    return parts.length > 1 ? parts[1] : '--:--';
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
                          width: 36, height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Reservasi Lapangan', 
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('${widget.field.name} · ${widget.field.type}',
                        style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5))),
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
                    children: ['Lapangan A', 'Lapangan B', 'Lapangan C'].map((sub) {
                      bool isSelected = _selectedSubField == sub;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedSubField = sub),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.accent : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: isSelected ? AppColors.accent : AppColors.border),
                            ),
                            child: Center(
                              child: Text(
                                sub,
                                style: TextStyle(
                                  color: isSelected ? AppColors.darkGreen : AppColors.textPrimary,
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
                  _sectionLabel('Pilih Waktu'),
                  const SizedBox(height: 10),
                  _buildTimeGrid(),
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
            onTap: () => setState(() => _selectedDateIndex = i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 54,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.darkGreen : AppColors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: isSelected ? AppColors.darkGreen : AppColors.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_dates[i].day, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white60 : AppColors.textSecondary)),
                  Text(_dates[i].num, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isSelected ? AppColors.accent : AppColors.textPrimary)),
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
        crossAxisCount: 2, childAspectRatio: 2.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
      itemCount: AppData.timeSlots.length,
      itemBuilder: (_, i) {
        final slot = AppData.timeSlots[i];
        final isTaken = AppData.bookedSlots.contains(slot);
        final isSelected = _selectedTime == slot;
        return GestureDetector(
          onTap: isTaken ? null : () => setState(() => _selectedTime = slot),
          child: Container(
            decoration: BoxDecoration(
              color: isTaken ? AppColors.cardBg : isSelected ? AppColors.darkGreen : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? AppColors.darkGreen : AppColors.border),
            ),
            child: Center(
              child: Text(slot, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, 
                color: isTaken ? Colors.grey : isSelected ? AppColors.accent : AppColors.textPrimary)),
            ),
          ),
        );
      },
    );
  }


  Widget _buildBottomSummary() {
    if (_selectedTime == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
        child: _buildConfirmButton(),
      ),
    );
  }

  Widget _buildConfirmButton() {
    return SizedBox(
      width: double.infinity, height: 56,
      child: ElevatedButton(
        onPressed: () {
          final booking = Booking(
            bookingCode: _generateBookingCode(),
            field: widget.field,
            subField: _selectedSubField,
            date: DateTime.now(),
            startTime: _startTime,
            endTime: _endTime,
            durationHours: 2,
            totalPrice: _totalPrice,
          );
          AppData.recentBookings.insert(0, booking);
          Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentScreen(booking: booking)));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkGreen, 
          foregroundColor: AppColors.accent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 0,
        ),
        child: const Text('Lanjutkan Pembayaran →', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ),
    );
  }

  Widget _sectionLabel(String text) => Text(text.toUpperCase(), style: AppTextStyles.caption);
  Widget _summaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 13, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: isTotal ? AppColors.darkGreen : AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _DateItem {
  final String day, num;
  const _DateItem({required this.day, required this.num});
}