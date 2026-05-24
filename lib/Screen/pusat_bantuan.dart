import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Pastikan package ini sudah didaftarkan di pubspec.yaml
import '../theme/app_theme.dart';

class PusatBantuanPage extends StatefulWidget {
  const PusatBantuanPage({super.key});

  @override
  State<PusatBantuanPage> createState() => _PusatBantuanPageState();
}

class _PusatBantuanPageState extends State<PusatBantuanPage> {
  // Data Dummy Informasi Pertanyaan & Jawaban FAQ
  final List<Map<String, String>> _allFaq = [
    {
      'pertanyaan': 'Bagaimana cara membatalkan pesanan?',
      'jawaban': 'Anda dapat membatalkan pesanan langsung melalui menu Riwayat Transaksi maksimal 2 jam sebelum jadwal tanding dimulai. Dana Anda akan otomatis dikembalikan dalam bentuk saldo aplikasi.',
    },
    {
      'pertanyaan': 'Mengapa status pembayaran saya belum berubah?',
      'jawaban': 'Proses verifikasi pembayaran otomatis biasanya memakan waktu 1-5 menit. Jika dalam 10 menit status belum berubah, mohon hubungi tim Live Chat kami dengan melampirkan bukti transfer Anda.',
    },
    {
      'pertanyaan': 'Berapa lama batas waktu pembayaran?',
      'jawaban': 'Batas waktu pembayaran untuk setiap reservasi lapangan futsal adalah 15 menit setelah pesanan dibuat. Jika melewati batas waktu tersebut, pesanan Anda akan otomatis dibatalkan oleh sistem.',
    },
  ];

  // Variabel penampung hasil filter pencarian
  List<Map<String, String>> _filteredFaq = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Menampilkan seluruh daftar FAQ di awal halaman dibuka
    _filteredFaq = _allFaq;
  }

  // Fungsi pencarian untuk menyaring FAQ secara otomatis sewaktu user mengetik
  void _filterSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredFaq = _allFaq;
      } else {
        _filteredFaq = _allFaq
            .where((faq) => faq['pertanyaan']!
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  // Fungsi langsung untuk memicu pembukaan aplikasi Gmail di HP
  Future<void> _launchEmail({String subject = ''}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'futsal@gmail.com', // Alamat email tujuan utama
      queryParameters: {
        'subject': subject.isEmpty ? 'Tanya FutsalKu' : subject,
        'body': 'Halo Tim Dukungan FutsalKu,\n\nSaya ingin bertanya mengenai...'
      },
    );

    try {
      // Menggunakan mode externalApplication agar langsung dipaksa membuka aplikasi Gmail bawaan
      await launchUrl(emailLaunchUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka aplikasi email. Pastikan HP Anda memiliki aplikasi Gmail aktif.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3EF),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER UTAMA
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

                    // INPUT PENCARIAN (AKTIF)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                      child: TextField(
                        controller: _searchController,
                        onChanged: _filterSearch,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search),
                          hintText: "Cari masalah atau panduan...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // KARTU PANDUAN PEMULA
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

                    const SizedBox(height: 28),
                    Row(
                      children: [
                        const Expanded(child: Text("FAQ Terpopuler", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                        Container(width: 40, height: 3, color: AppColors.darkGreen)
                      ],
                    ),

                    const SizedBox(height: 18),

                    // DAFTAR FAQ ACCORDION (BISA DITEKAN & BUKA-TUTUP)
                    _filteredFaq.isEmpty
                        ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(
                        child: Text(
                          "Pertanyaan tidak ditemukan.",
                          style: TextStyle(color: Colors.black45, fontStyle: FontStyle.italic),
                        ),
                      ),
                    )
                        : Column(
                      children: _filteredFaq.map((faq) => _buildFaqItem(faq['pertanyaan']!, faq['jawaban']!)).toList(),
                    ),

                    const SizedBox(height: 24),

                    // KARTU DUKUNGAN (HANYA TOMBOL KIRIM EMAIL)
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

                          // SEKARANG LANGSUNG TOMBOL KIRIM EMAIL (LIVE CHAT SUDAH DIHAPUS)
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 15),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                side: const BorderSide(color: AppColors.darkGreen, width: 1.5),
                              ),
                              onPressed: () {
                                _launchEmail(subject: '[TIKET] Pertanyaan Aplikasi FutsalKu');
                              },
                              icon: const Icon(Icons.email, color: AppColors.darkGreen),
                              label: const Text("Kirim Email", style: TextStyle(color: AppColors.darkGreen, fontWeight: FontWeight.bold)),
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

  // Fungsi Pembuat Komponen Dropdown FAQ Menggunakan ExpansionTile Tanpa Garis Pembatas
  Widget _buildFaqItem(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          iconColor: AppColors.darkGreen,
          collapsedIconColor: Colors.black54,
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.black),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                content,
                style: TextStyle(color: Colors.black.withOpacity(0.65), height: 1.3),
              ),
            )
          ],
        ),
      ),
    );
  }
}