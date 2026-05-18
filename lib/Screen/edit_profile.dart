import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController nameC = TextEditingController(text: "Gde Radeva Putra Suniantara");
  final TextEditingController emailC = TextEditingController(text: "radevaputra@email.com");
  final TextEditingController phoneC = TextEditingController(text: "+62 812-3456-7890");

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
                      "Profile",
                      style: TextStyle(color: AppColors.darkGreen, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Profile berhasil disimpan")),
                      );
                    },
                    child: const Text("Save", style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
            const Divider(height: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    // PROFILE CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.70),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.accent, width: 3),
                                ),
                                child: const CircleAvatar(
                                  radius: 46,
                                  backgroundImage: NetworkImage("https://ui-avatars.com/api/?name=Ahmad+Rivaldo&background=1A1F2E&color=fff&size=256"),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.darkGreen),
                                  child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(nameC.text, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.darkGreen)),
                          const SizedBox(height: 4),
                          Text("Striker • Jakarta Selatan", style: TextStyle(color: Colors.black.withOpacity(.55))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),
                    const Align(alignment: Alignment.centerLeft, child: Text("Personal Information", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))),
                    const SizedBox(height: 8),
                    Align(alignment: Alignment.centerLeft, child: Container(width: 170, height: 3, color: AppColors.accent.withOpacity(.4))),
                    const SizedBox(height: 22),

                    _label("FULL NAME"),
                    const SizedBox(height: 8),
                    _inputField(Icons.person, nameC),

                    const SizedBox(height: 18),
                    _label("EMAIL ADDRESS"),
                    const SizedBox(height: 8),
                    _inputField(Icons.email, emailC),

                    const SizedBox(height: 18),
                    _label("PHONE NUMBER"),
                    const SizedBox(height: 8),
                    _inputField(Icons.phone, phoneC),

                    const SizedBox(height: 28),

                    // SECURITY BOX
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.70),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: const [
                              Expanded(child: Text("Account Security", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.darkGreen))),
                              Icon(Icons.shield, color: AppColors.darkGreen)
                            ],
                          ),
                          const SizedBox(height: 16),
                          _menuBox("Change Password"),
                          const SizedBox(height: 12),
                          _menuBox("Social Account Links", icon: Icons.link),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onPressed: () {
                          setState(() {});
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile updated")));
                        },
                        child: const Text("Update Profile", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text("Deactivate Account", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(alignment: Alignment.centerLeft, child: Text(text, style: TextStyle(fontSize: 11, letterSpacing: 2, fontWeight: FontWeight.bold, color: Colors.black.withOpacity(.55))));
  }

  Widget _inputField(IconData icon, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(color: Colors.white.withOpacity(.70), borderRadius: BorderRadius.circular(16)),
      child: TextField(controller: controller, decoration: InputDecoration(icon: Icon(icon, color: AppColors.darkGreen), border: InputBorder.none)),
    );
  }

  Widget _menuBox(String title, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Icon(icon ?? Icons.arrow_forward_ios, size: 15, color: AppColors.darkGreen)
        ],
      ),
    );
  }
}
