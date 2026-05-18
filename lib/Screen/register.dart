import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passController = TextEditingController();
  final _confirmPassController = TextEditingController();
  
  bool _obscurePass = true;
  bool _obscureConfirm = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1F2E), 
              Color(0xFF0F3D2E), 
              Color(0xFF1A3A20), 
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                ),
                
                const SizedBox(height: 24),
                const Text(
                  'Buat Akun Baru.',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lengkapi data dirimu untuk mulai memesan lapangan.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),

                const SizedBox(height: 40),
                _buildLabel('Nama Lengkap'),
                _buildTextField(_nameController, 'Budi Santoso', Icons.person_outline),

                const SizedBox(height: 20),
                _buildLabel('Email'),
                _buildTextField(_emailController, 'nama@email.com', Icons.email_outlined, keyboardType: TextInputType.emailAddress),

                const SizedBox(height: 20),
                _buildLabel('Nomor Telepon'),
                _buildTextField(_phoneController, '0812xxxx', Icons.phone_android_outlined, keyboardType: TextInputType.phone),

                const SizedBox(height: 20),
                _buildLabel('Kata Sandi'),
                _buildTextField(
                  _passController, 
                  '••••••••', 
                  Icons.lock_outline, 
                  obscureText: _obscurePass,
                  suffix: _buildVisibilityToggle(_obscurePass, () => setState(() => _obscurePass = !_obscurePass)),
                ),

                const SizedBox(height: 20),
                _buildLabel('Konfirmasi Kata Sandi'),
                _buildTextField(
                  _confirmPassController, 
                  '••••••••', 
                  Icons.lock_outline, 
                  obscureText: _obscureConfirm,
                  suffix: _buildVisibilityToggle(_obscureConfirm, () => setState(() => _obscureConfirm = !_obscureConfirm)),
                ),

                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent, 
                      foregroundColor: AppColors.darkGreen,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Daftar Sekarang',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: RichText(
                      text: TextSpan(
                        text: 'Sudah punya akun? ',
                        style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14),
                        children: const [
                          TextSpan(
                            text: 'Masuk di sini',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.white.withOpacity(0.4),
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon, {bool obscureText = false, TextInputType? keyboardType, Widget? suffix}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 15),
        prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1),
        ),
      ),
    );
  }

  Widget _buildVisibilityToggle(bool isObscure, VoidCallback onToggle) {
    return IconButton(
      onPressed: onToggle,
      icon: Icon(
        isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
        color: Colors.white.withOpacity(0.3),
        size: 20,
      ),
    );
  }
}