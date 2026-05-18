import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class KeamananPasswordPage extends StatefulWidget {
  const KeamananPasswordPage({super.key});

  @override
  State<KeamananPasswordPage> createState() => _KeamananPasswordPageState();
}

class _KeamananPasswordPageState extends State<KeamananPasswordPage> {
  bool _biometricEnabled = true;
  bool _twoStepEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3EF),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.darkGreen),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Keamanan",
                      style: TextStyle(color: AppColors.darkGreen, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Kelola Keamanan\nAkun Anda",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, height: 1.1),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Pastikan akun Anda tetap aman dengan fitur keamanan terbaru.",
                      style: TextStyle(color: Colors.black.withOpacity(0.55)),
                    ),
                    const SizedBox(height: 32),

                    _sectionLabel("KATA SANDI"),
                    const SizedBox(height: 12),
                    _securityCard(
                      title: "Ubah Kata Sandi",
                      subtitle: "Terakhir diubah 3 bulan lalu",
                      icon: Icons.lock_outline_rounded,
                      onTap: () => _showChangePasswordSheet(context),
                    ),

                    const SizedBox(height: 32),
                    _sectionLabel("AUTENTIKASI"),
                    const SizedBox(height: 12),
                    _toggleCard(
                      title: "Login Biometrik",
                      subtitle: "Gunakan Sidik Jari / Face ID",
                      icon: Icons.fingerprint_rounded,
                      value: _biometricEnabled,
                      onChanged: (val) => setState(() => _biometricEnabled = val),
                    ),
                    const SizedBox(height: 12),
                    _toggleCard(
                      title: "Verifikasi 2 Langkah",
                      subtitle: "Lapisan keamanan tambahan via SMS/Email",
                      icon: Icons.verified_user_outlined,
                      value: _twoStepEnabled,
                      onChanged: (val) => setState(() => _twoStepEnabled = val),
                    ),

                    const SizedBox(height: 32),
                    _sectionLabel("PERANGKAT TERHUBUNG"),
                    const SizedBox(height: 12),
                    _securityCard(
                      title: "Daftar Perangkat",
                      subtitle: "2 Perangkat aktif saat ini",
                      icon: Icons.devices_rounded,
                      onTap: () {},
                    ),

                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.orange.withOpacity(0.2)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded, color: Colors.orange),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text("Tips Keamanan", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                                Text("Gunakan kombinasi simbol dan angka untuk sandi yang lebih kuat.", style: TextStyle(fontSize: 12, color: Colors.black87)),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black.withOpacity(0.4), letterSpacing: 1.5),
    );
  }

  Widget _securityCard({required String title, required String subtitle, required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.darkGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: AppColors.darkGreen, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black26),
          ],
        ),
      ),
    );
  }

  Widget _toggleCard({required String title, required String subtitle, required IconData icon, required bool value, required Function(bool) onChanged}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.darkGreen.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.darkGreen, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 12)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.accent,
            activeTrackColor: AppColors.accent.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 24),
            const Text("Ubah Kata Sandi", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            _modalInput("Kata Sandi Lama", true),
            const SizedBox(height: 16),
            _modalInput("Kata Sandi Baru", true),
            const SizedBox(height: 16),
            _modalInput("Konfirmasi Kata Sandi Baru", true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.darkGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => Navigator.pop(context),
                child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _modalInput(String label, bool isPassword) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        const SizedBox(height: 8),
        TextField(
          obscureText: isPassword,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
