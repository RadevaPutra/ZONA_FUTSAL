import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'booking.dart';
import 'schedule.dart';
import 'profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedNav = 0;

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'Beranda'),
    _NavItem(icon: Icons.calendar_today_rounded, label: 'Jadwal'),
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
              return GestureDetector(
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

class _HomeContentState extends State<HomeContent> {
  @override
  Widget build(BuildContext context) {
    // Simulasi data (Ganti ke [] untuk melihat tampilan kosong)
    List<Booking> activeBookings = AppData.recentBookings.where((b) => b.status == 'Aktif').toList();
    List<Booking> recentHistory = AppData.recentBookings.where((b) => b.status == 'Selesai').toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildHeader(), // Termasuk Lokasi & Notifikasi
          const SizedBox(height: 24),
          
          // 1. Pengingat Lapangan / Empty State Jadwal
          activeBookings.isEmpty 
            ? _buildEmptyJadwal() 
            : _buildBookingReminder(activeBookings.first),

          const SizedBox(height: 32),
          _buildSectionHeader('LAPANGAN TERSEDIA', () {}),
          _buildAvailableFields(),

          const SizedBox(height: 32),
          
          // 2. Riwayat Terbaru / Recently
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RIWAYAT TERBARU', style: AppTextStyles.caption),
                const SizedBox(height: 16),
                recentHistory.isEmpty 
                  ? _buildEmptyHistory() 
                  : _buildRecentHistoryList(recentHistory),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // HEADER: Lokasi di sebelah notifikasi & Icon Lokasi Pengguna
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
          // Icon Notifikasi & Lokasi
          Row(
            children: [
              _headerIcon(Icons.notifications_none_rounded),
              const SizedBox(width: 10),
              _headerIcon(Icons.my_location_rounded), // Icon lokasi pengguna
            ],
          )
        ],
      ),
    );
  }

  // EMPTY STATE: Jika tidak ada jadwal
  Widget _buildEmptyJadwal() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_busy_rounded, color: Colors.white24, size: 50),
          const SizedBox(height: 12),
          const Text("Belum ada jadwal booking", 
            style: TextStyle(color: Colors.white38, fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // REMINDER: Jika sudah memesan lapangan
  Widget _buildBookingReminder(Booking booking) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkGreen, Color(0xFF1A3A20)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.accent, size: 40),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("PENGINGAT BOOKING", style: TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(booking.field.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("${booking.subField} • ${booking.startTime}", style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTextStyles.caption),
          GestureDetector(
            onTap: onTap,
            child: const Text('Lihat semua', style: TextStyle(fontSize: 12, color: AppColors.accent, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableFields() {
    return SizedBox(
      height: 170,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: AppData.fields.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _FieldCard(
          field: AppData.fields[i],
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BookingScreen(field: AppData.fields[i]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      padding: const EdgeInsets.all(30),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Icon(Icons.history_rounded, color: Colors.white10, size: 40),
          const SizedBox(height: 12),
          const Text("Belum ada riwayat pesanan", 
            style: TextStyle(color: Colors.white24, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildRecentHistoryList(List<Booking> history) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final booking = history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.sports_soccer, color: AppColors.accent, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.field.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 2),
                    Text("${booking.subField} • ${booking.startTime}", style: const TextStyle(color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.check_circle_rounded, color: Colors.green, size: 18),
            ],
          ),
        );
      },
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