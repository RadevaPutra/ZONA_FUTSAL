import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import 'edit_profile.dart';
import 'login.dart';
import 'notifikasi.dart';
import 'pusat_bantuan.dart';
import 'keamanan_password.dart';
import 'riwayat_transaksi.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});



  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String nama = '';
  String email = '';
  String? foto; // Menangkap string foto profil terbaru



  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    print('FOTO PROFILE SCREEN: ${prefs.getString('foto')}');

    setState(() {
      nama = prefs.getString('nama') ?? '';
      email = prefs.getString('email') ?? '';
      foto = prefs.getString('foto');
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1F2E),
              Color(0xFF0F3D2E),
            ],
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),

            // UI Dinamis Avatar: Deteksi foto network dari folder uploads API backend
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.6),
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                radius: 55,
                backgroundColor: const Color(0xFF0F3D2E),
                backgroundImage: (foto != null && foto!.isNotEmpty)
                    ? NetworkImage(
                  'http://10.0.2.2:3000/uploads/$foto?v=${DateTime.now().millisecondsSinceEpoch}',
                )
                    : null,
                child: (foto == null || foto!.isEmpty)
                    ? Text(
                  nama.isNotEmpty ? nama[0].toUpperCase() : "U",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                  ),
                )
                    : null,
              ),
            ),

            const SizedBox(height: 20),
            Text(
              nama,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              email,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.20),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  children: [
                    _menu(
                      context,
                      Icons.person_outline,
                      "Edit Profil",
                          () async {
                        // Menunggu eksekusi halaman edit selesai
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EditProfilePage(),
                          ),
                        );
                        // Saat kembali dari EditProfilePage, otomatis panggil loadUser() untuk memperbarui Avatar
                        loadUser();
                      },
                    ),
                    _menu(
                      context,
                      Icons.notifications_none,
                      "Notifikasi",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotifikasiPage(),
                          ),
                        );
                      },
                    ),
                    _menu(
                      context,
                      Icons.history,
                      "Riwayat Transaksi",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RiwayatTransaksiPage(),
                          ),
                        );
                      },
                    ),
                    _menu(
                      context,
                      Icons.security,
                      "Keamanan & Password",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const KeamananPasswordPage(),
                          ),
                        );
                      },
                    ),
                    _menu(
                      context,
                      Icons.help_outline,
                      "Pusat Bantuan",
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PusatBantuanPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      color: Colors.white12,
                      thickness: 1,
                      indent: 20,
                      endIndent: 20,
                    ),
                    const SizedBox(height: 10),
                    _menu(
                      context,
                      Icons.logout,
                      "Keluar",
                          () {
                        logout();
                      },
                      isLogout: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menu(
      BuildContext context,
      IconData icon,
      String title,
      VoidCallback onTap, {
        bool isLogout = false,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isLogout ? Colors.redAccent : AppColors.accent,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isLogout ? Colors.redAccent : Colors.white,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 15,
          color: isLogout ? Colors.redAccent : Colors.white38,
        ),
        onTap: onTap,
      ),
    );
  }
}