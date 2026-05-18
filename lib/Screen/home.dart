import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'booking.dart';
import 'schedule.dart';
import 'profile.dart';
import '../widgets/ball_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Beranda'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Lapangan'),
    _NavItem(icon: Icons.person_rounded, label: 'Profil'),
  ];

  final List<Widget> _pages = [
    const HomeContent(),
    const ScheduleScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E0D),
      body: _pages[_selectedNav],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0F1A15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (i) {
              final item = _navItems[i];
              final isActive = _selectedNav == i;
              return FeatureBallAnimation(
                onTap: () => setState(() => _selectedNav = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.accent.withOpacity(0.1) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        item.icon,
                        color: isActive ? AppColors.accent : Colors.white38,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive ? AppColors.accent : Colors.white38,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool get hasActiveBooking => AppData.recentBookings.isNotEmpty; 
  bool isNearMeActive = false;
  String _activeHistoryFilter = 'Semua';
  final List<String> _historyFilters = ['Semua', 'Hari ini', '3 Hari', '7 Hari', 'Bulan lalu'];

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  List<Booking> get _filteredHistory {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return AppData.recentBookings.where((booking) {
      if (_activeHistoryFilter == 'Semua') return true;
      final bookingDate = DateTime(booking.date.year, booking.date.month, booking.date.day);
      final difference = today.difference(bookingDate).inDays;

      if (_activeHistoryFilter == 'Hari ini') {
        return difference == 0;
      } else if (_activeHistoryFilter == '3 Hari') {
        return difference >= 0 && difference <= 3;
      } else if (_activeHistoryFilter == '7 Hari') {
        return difference >= 0 && difference <= 7;
      } else if (_activeHistoryFilter == 'Bulan lalu') {
        // Last month logic
        int lastMonth = now.month - 1;
        int year = now.year;
        if (lastMonth == 0) {
          lastMonth = 12;
          year -= 1;
        }
        return booking.date.year == year && booking.date.month == lastMonth;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeader(), 
              const SizedBox(height: 24),
              _sectionLabel("Jadwal Anda"),
              const SizedBox(height: 12),
              hasActiveBooking 
                  ? _buildBookingReminder() 
                  : _buildEmptyState(Icons.event_busy_rounded, "Tidak ada jadwal tanding"),

              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _sectionLabel("Lapangan Tersedia"),
                    GestureDetector(
                      onTap: () => setState(() => isNearMeActive = !isNearMeActive),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isNearMeActive ? AppColors.accent : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isNearMeActive ? AppColors.accent : Colors.white10),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.near_me_rounded, 
                                 size: 14, 
                                 color: isNearMeActive ? Colors.black : Colors.white70),
                            const SizedBox(width: 6),
                            Text("Near Me", 
                                 style: TextStyle(
                                   color: isNearMeActive ? Colors.black : Colors.white70,
                                   fontSize: 11,
                                   fontWeight: FontWeight.bold,
                                 )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _buildFieldList(),

              const SizedBox(height: 32),
              _sectionLabel("Riwayat"),
              const SizedBox(height: 12),
              _buildHistoryFilterBar(),
              const SizedBox(height: 12),
              _buildHistoryList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryFilterBar() {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _historyFilters.length,
        itemBuilder: (context, index) {
          final filter = _historyFilters[index];
          final isActive = _activeHistoryFilter == filter;
          return GestureDetector(
            onTap: () => setState(() => _activeHistoryFilter = filter),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isActive ? AppColors.accent : Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isActive ? AppColors.accent : Colors.white.withOpacity(0.1),
                ),
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isActive ? Colors.black : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryList() {
    final filtered = _filteredHistory;
    if (filtered.isEmpty) {
      return _buildEmptyState(Icons.event_busy_rounded, "Belum ada riwayat pesanan");
    }
    
    return Column(
      children: filtered.map((booking) => _buildHistoryItem(booking)).toList(),
    );
  }

  Widget _buildHistoryItem(Booking booking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.sports_soccer, color: AppColors.accent, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.field.name, 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text("${booking.subField} • ${booking.startTime}", 
                  style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          Text(
            "Rp ${booking.totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}",
            style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        ],
      ),
    );
  }
  Widget _sectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
  Widget _buildEmptyState(IconData icon, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white12, size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(color: Colors.white38, fontSize: 13),
          ),
        ],
      ),
    );
  }
  Widget _buildBookingReminder() {
    final booking = AppData.recentBookings.first;
    final formattedDate = DateFormat('EEEE, dd MMM yyyy').format(booking.date);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF0F3D2E), Color(0xFF1A3A20)]),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.accent, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("JADWAL TERDEKAT", style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold, fontSize: 10)),
                Text("${booking.field.name} - ${booking.subField}", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Text("$formattedDate, ${booking.startTime} - ${booking.endTime}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFieldList() {
    final displayFields = isNearMeActive 
        ? AppData.fields.where((f) => f.location.toLowerCase().contains("bojongsoang")).toList()
        : AppData.fields.where((f) => f.location.toLowerCase().contains("bandung")).toList();

    if (displayFields.isEmpty) {
      return _buildEmptyState(
        isNearMeActive ? Icons.near_me_disabled_rounded : Icons.location_off_rounded, 
        isNearMeActive ? "Tidak ada lapangan di Bojongsoang" : "Tidak ada lapangan di Bandung"
      );
    }

    return SizedBox(
      height: 185,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 20),
        itemCount: displayFields.length,
        itemBuilder: (context, index) => _buildFieldCard(displayFields[index]),
      ),
    );
  }

  Widget _buildFieldCard(Field field) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: FeatureBallAnimation(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BookingScreen(field: field),
          ),
        ),
        child: _FieldCard(
          field: field,
          onTap: () {}, // Handled by FeatureBallAnimation
        ),
      ),
    );
  }
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Halo, Gde Radeva!", style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Row(
                children: const [
                  Icon(Icons.location_on, color: AppColors.accent, size: 16),
                  SizedBox(width: 4),
                  Text("Bojongsoang, Bandung", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
          Row(
            children: [
              _headerIcon(Icons.notifications_none_rounded),
              const SizedBox(width: 10),
              _headerIcon(Icons.my_location_rounded), 
            ],
          )
        ],
      ),
    );
  }
  Widget _headerIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.08), shape: BoxShape.circle),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }
}
class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}
class _FieldCard extends StatelessWidget {
  final Field field;
  final VoidCallback onTap;

  const _FieldCard({required this.field, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 165,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: field.isAvailable
                ? [const Color(0xFF0F3D2E), const Color(0xFF1A5A3E)]
                : [const Color(0xFF2A2A2A), const Color(0xFF3A3A3A)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: field.isAvailable
                    ? AppColors.accent.withOpacity(0.2)
                    : AppColors.busy.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                field.isAvailable ? 'Tersedia' : 'Penuh',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: field.isAvailable ? AppColors.accent : AppColors.busy,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Spacer(),
            Text(
              field.name,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '${field.type} · ${field.location}',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.45),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp ${_formatPrice(field.pricePerHour)}/jam',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: field.isAvailable ? AppColors.accent : AppColors.busy,
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}