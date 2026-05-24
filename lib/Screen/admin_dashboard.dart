import 'package:flutter/material.dart';
import '../models/models.dart';
import '../models/voucher_model.dart';
import 'login.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const AdminOverview(),
    const AdminFieldManagement(),
    const AdminBookingManagement(),
    const AdminVoucherManagement(),
    const AdminUserManagement(),
    const AdminSupportManagement(),
  ];

  final List<String> _titles = [
    '📊 Dashboard Overview',
    '🏟️ Manajemen Lapangan',
    '📝 Manajemen Booking',
    '🎟️ Manajemen Promo',
    '👥 Manajemen Pengguna',
    '🎧 Pusat Bantuan',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(_titles[_selectedIndex], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_active, color: Color(0xFF00E676)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Keluar',
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1E1E),
        selectedItemColor: const Color(0xFF00E676),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.sports_soccer), label: 'Lapangan'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Booking'),
          BottomNavigationBarItem(icon: Icon(Icons.local_offer), label: 'Voucher'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
          BottomNavigationBarItem(icon: Icon(Icons.headset_mic), label: 'Support'),
        ],
      ),
    );
  }
}

// ==========================================
// 1. DASHBOARD OVERVIEW
// ==========================================
class AdminOverview extends StatelessWidget {
  const AdminOverview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Revenue\n(Bulan Ini)', 'Rp 12,4 Jt', Icons.monetization_on, Colors.blue)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Booking Hari Ini\n(Menunggu)', '8', Icons.calendar_today, Colors.orange)),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Total Pengguna', '1,582', Icons.people, Colors.purple)),
            const SizedBox(width: 16),
            Expanded(child: _buildStatCard('Lapangan Aktif', '${AppData.fields.length}', Icons.sports_soccer, const Color(0xFF00E676))),
          ],
        ),
        const SizedBox(height: 24),
        const Text('Grafik Pemesanan (Pekan Ini)', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white10),
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.bar_chart, color: Colors.grey, size: 64),
                SizedBox(height: 8),
                Text('Widget Grafik Fluktuasi Booking', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );
  }
}

// ==========================================
// 2. MANAJEMEN LAPANGAN (Field Management)
// ==========================================
class AdminFieldManagement extends StatefulWidget {
  const AdminFieldManagement({Key? key}) : super(key: key);

  @override
  State<AdminFieldManagement> createState() => _AdminFieldManagementState();
}

class _AdminFieldManagementState extends State<AdminFieldManagement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AppData.fields.length,
        itemBuilder: (context, index) {
          final field = AppData.fields[index];
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(field.image, width: 60, height: 60, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.image, color: Colors.grey)),
              ),
              title: Text(field.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('${field.type} • Rp ${field.pricePerHour}/jam', style: const TextStyle(color: Colors.grey)),
              trailing: Switch(
                value: field.isAvailable,
                activeColor: const Color(0xFF00E676),
                onChanged: (val) {
                  // Simulasi Toggle Ketersediaan (Renovasi)
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Status Ketersediaan Diubah')));
                },
              ),
              onTap: () {
                // Form edit tap
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

// ==========================================
// 3. MANAJEMEN PEMESANAN (Booking)
// ==========================================
class AdminBookingManagement extends StatelessWidget {
  const AdminBookingManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulasi data jika kosong
    if (AppData.recentBookings.isEmpty) {
      return const Center(child: Text('Belum ada transaksi.', style: TextStyle(color: Colors.grey)));
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: AppData.recentBookings.length,
      itemBuilder: (context, index) {
        final booking = AppData.recentBookings[index];
        return Card(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order ID: ${booking.bookingCode}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    _buildStatusChip(booking.status),
                  ],
                ),
                const Divider(color: Colors.white10, height: 24),
                Text('Lapangan: ${booking.field.name} (${booking.subField})', style: const TextStyle(color: Colors.white70)),
                Text('Waktu: ${booking.date.toString().substring(0,10)} | ${booking.startTime} - ${booking.endTime}', style: const TextStyle(color: Colors.white70)),
                Text('Total Bayar: Rp ${booking.totalPrice}', style: const TextStyle(color: const Color(0xFF00E676), fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.receipt_long, color: Colors.blue),
                      label: const Text('Cek Bukti Bayar', style: TextStyle(color: Colors.blue)),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                      onPressed: () {},
                      child: const Text('Validasi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.orange;
    if (status.toUpperCase() == 'LUNAS' || status.toUpperCase() == 'Selesai') color = const Color(0xFF00E676);
    if (status.toUpperCase() == 'BATAL') color = Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        border: Border.all(color: color.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}

// ==========================================
// 4. MANAJEMEN VOUCHER (Promo)
// ==========================================
class AdminVoucherManagement extends StatelessWidget {
  const AdminVoucherManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: VoucherData.availableVouchers.length,
        itemBuilder: (context, index) {
          final voucher = VoucherData.availableVouchers[index];
          final bool isExpired = voucher.isExpired;
          return Card(
            color: const Color(0xFF1E1E1E),
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: const Color(0xFF00E676).withOpacity(0.2),
                child: Text(voucher.iconEmoji, style: const TextStyle(fontSize: 20)),
              ),
              title: Text(voucher.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text('Kode: ${voucher.code}\nDiskon: ${voucher.discountValue}${voucher.type == VoucherType.percent ? '%' : ' IDR'}', style: const TextStyle(color: Colors.grey)),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: isExpired ? Colors.red.withOpacity(0.2) : const Color(0xFF00E676).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(isExpired ? 'Expired' : 'Aktif', style: TextStyle(color: isExpired ? Colors.red : const Color(0xFF00E676), fontSize: 12)),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF00E676),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {},
      ),
    );
  }
}

// ==========================================
// 5. MANAJEMEN PENGGUNA (User)
// ==========================================
class AdminUserManagement extends StatelessWidget {
  const AdminUserManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Simulasi List User
    final List<Map<String, String>> users = [
      {'name': 'Radeva Putra', 'email': 'radeva@example.com', 'status': 'Active'},
      {'name': 'Daniel Carter', 'email': 'daniel@example.com', 'status': 'Active'},
      {'name': 'Fake Faker', 'email': 'fake123@example.com', 'status': 'Banned'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final u = users[index];
        final isBanned = u['status'] == 'Banned';
        return Card(
          color: const Color(0xFF1E1E1E),
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: Colors.grey[800], child: const Icon(Icons.person, color: Colors.white)),
            title: Text(u['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(u['email']!, style: const TextStyle(color: Colors.grey)),
            trailing: IconButton(
              icon: Icon(isBanned ? Icons.lock_open : Icons.block, color: isBanned ? Colors.green : Colors.red),
              onPressed: () {},
            ),
          ),
        );
      },
    );
  }
}

// ==========================================
// 6. PUSAT BANTUAN (Support/Tickets)
// ==========================================
class AdminSupportManagement extends StatelessWidget {
  const AdminSupportManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildTicketCard('Kenapa kode booking saya tidak muncul?', 'Sarah Lee', '1 Jam yang lalu', false),
        _buildTicketCard('Pengajuan Refund - Hujan Deras Lapangan Bocor', 'Michael R.', '3 Jam yang lalu', true),
        _buildTicketCard('Bagaimana cara pakai Voucher MAIN 2 JAM?', 'Radeva Putra', '1 Hari yang lalu', true),
      ],
    );
  }

  Widget _buildTicketCard(String issue, String user, String time, bool isResolved) {
    return Card(
      color: const Color(0xFF1E1E1E),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                Text(time, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
            const SizedBox(height: 8),
            Text('Q: "$issue"', style: const TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isResolved ? Colors.green.withOpacity(0.2) : Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(isResolved ? 'Resolved' : 'Pending', style: TextStyle(color: isResolved ? Colors.green : Colors.orange, fontSize: 12)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00E676)),
                  onPressed: () {},
                  child: const Text('Balas Pesan', style: TextStyle(color: Colors.white)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
