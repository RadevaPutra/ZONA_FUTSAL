import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent.withOpacity(0.5), width: 4),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: const CircleAvatar(
                radius: 55,
                backgroundColor: Color(0xFF0F3D2E),
                backgroundImage: NetworkImage(
                  'https://ui-avatars.com/api/?name=Gde+Radeva&background=0F3D2E&color=fff&size=256'
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Gde Radeva Putra Suniantara",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "radevaputra@gmail.com",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(35),
                    topRight: Radius.circular(35),
                  ),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    _profileMenu(Icons.person_outline_rounded, "Edit Profil"),
                    _profileMenu(Icons.notifications_none_rounded, "Notifikasi"),
                    _profileMenu(Icons.history_rounded, "Riwayat Transaksi"),
                    _profileMenu(Icons.security_rounded, "Keamanan & Password"),
                    _profileMenu(Icons.help_outline_rounded, "Pusat Bantuan"),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Divider(color: Colors.white10, thickness: 1),
                    ),
                    _profileMenu(Icons.logout_rounded, "Keluar", isLogout: true),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileMenu(IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isLogout ? Colors.redAccent.withOpacity(0.05) : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isLogout ? Colors.redAccent.withOpacity(0.1) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon, 
            color: isLogout ? Colors.redAccent : AppColors.accent,
            size: 22,
          ),
        ),
        title: Text(
          title, 
          style: TextStyle(
            color: isLogout ? Colors.redAccent : Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontSize: 15,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded, 
          size: 14, 
          color: isLogout ? Colors.redAccent.withOpacity(0.5) : Colors.white24,
        ),
        onTap: () {
        },
      ),
    );
  }
}