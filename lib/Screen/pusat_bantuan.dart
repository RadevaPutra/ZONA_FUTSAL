import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PusatBantuanPage extends StatelessWidget {
  const PusatBantuanPage({super.key});

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
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text("Pusat Bantuan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.darkGreen)),
                  ),
                  const Text("FutsalKu", style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.darkGreen))
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
                    const Text("Ada yang bisa\nkami bantu?", style: TextStyle(fontSize: 32, height: 1.1, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 18),

                    // SEARCH
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: const TextField(
                        decoration: InputDecoration(icon: Icon(Icons.search), hintText: "Cari masalah atau panduan...", border: InputBorder.none),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // CARD PANDUAN
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: AppColors.darkGreen, borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        children: [
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Panduan Pemula", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Text("Cara memesan lapangan & pembayaran", style: TextStyle(color: Colors.white70)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
                            child: const Icon(Icons.school, color: Colors.white),
                          )
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(child: _smallCard(Icons.payments, "Pembayaran", Colors.greenAccent)),
                        const SizedBox(width: 12),
                        Expanded(child: _smallCard(Icons.calendar_month, "Reservasi", Colors.lightBlueAccent)),
                      ],
                    ),

                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(child: Text("FAQ Terpopuler", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                        Container(width: 40, height: 3, color: AppColors.darkGreen)
                      ],
                    ),

                    const SizedBox(height: 18),
                    _faq("Bagaimana cara membatalkan pesanan?"),
                    _faq("Mengapa status pembayaran saya belum berubah?"),
                    _faq("Berapa lama batas waktu pembayaran?"),

                    const SizedBox(height: 24),

                    // SUPPORT CARD
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: Colors.white70, borderRadius: BorderRadius.circular(20)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Masih ada\npertanyaan?", style: TextStyle(fontSize: 28, height: 1.1, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Text("Tim dukungan kami siap membantu Anda 24/7.", style: TextStyle(color: Colors.black.withOpacity(.55))),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.darkGreen,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {},
                              icon: const Icon(Icons.chat, color: Colors.white),
                              label: const Text("Hubungi Live Chat", style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              onPressed: () {},
                              icon: const Icon(Icons.email),
                              label: const Text("Kirim Email"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _smallCard(IconData icon, String title, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(.2), child: Icon(icon)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _faq(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Expanded(child: Text(text, style: const TextStyle(fontWeight: FontWeight.w500))),
          const Icon(Icons.expand_more),
        ],
      ),
    );
  }
}
