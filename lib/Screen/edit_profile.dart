import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../theme/app_theme.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  File? imageFile;
  String? currentFotoPath; // Menyimpan nama file foto yang aktif dari backend

  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController phoneC = TextEditingController();

  int userId = 0;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    print('USER ID = ${prefs.getInt('user_id')}');
    print('PROFILE FOTO = ${prefs.getString('foto')}');

    setState(() {
      userId = prefs.getInt('user_id') ?? 0;
      nameC.text = prefs.getString('nama') ?? '';
      emailC.text = prefs.getString('email') ?? '';
      phoneC.text = prefs.getString('nomor_telepon') ?? '';
      currentFotoPath = prefs.getString('foto');
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      uploadPhoto();
    }
  }

  Future<void> uploadPhoto() async {
    if (imageFile == null) return;

    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('http://10.0.2.2:3000/api/auth/upload-photo/$userId'),
      );

      request.files.add(
        await http.MultipartFile.fromPath(
          'foto', // Field name untuk upload.single('foto') di Multer backend
          imageFile!.path,
        ),
      );

      var streamedResponse = await request.send();
      // FIX LOGIKA: Ubah stream ke Response biasa agar body JSON bisa dibaca
      var response = await http.Response.fromStream(streamedResponse);
      print('STATUS CODE = ${response.statusCode}');
      print('BODY = ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData =
        jsonDecode(response.body);

        print("UPLOAD RESPONSE:");
        print(response.body);
        print(responseData);

        // Deteksi dinamis berbagai macam nama properti JSON dari backend
        String newFotoName = '';
        if (responseData['foto_profile'] != null) {
          newFotoName = responseData['foto_profile'].toString();
        } else if (responseData['foto'] != null) {
          newFotoName = responseData['foto'].toString();
        } else if (responseData['filename'] != null) {
          newFotoName = responseData['filename'].toString();
        } else if (responseData['path'] != null) {
          newFotoName = responseData['path'].toString().split('/').last;
        } else if (responseData['image'] != null) {
          newFotoName = responseData['image'].toString();
        }

        // Jalur darurat jika backend tidak mengembalikan string nama file
        if (newFotoName.isEmpty) {
          newFotoName = imageFile!.path.split('/').last;
        }

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('foto', newFotoName); // Amankan ke SharedPreferences
        print('FOTO TERSIMPAN = $newFotoName');

        setState(() {
          currentFotoPath = newFotoName; // Perbarui tampilan lingkaran Avatar seketika
        });

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto berhasil diupload')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload gagal')),
        );
      }
    } catch (e) {
      print("Error Uploading Photo: $e");
    }
  }

  Future<void> updateProfile() async {
    try {
      final response = await http.put(
        Uri.parse('http://10.0.2.2:3000/api/auth/update-profile/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': nameC.text,
          'email': emailC.text,
          'nomor_telepon': phoneC.text,
        }),
      );

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('nama', nameC.text);
        await prefs.setString('email', emailC.text);
        await prefs.setString('nomor_telepon', phoneC.text);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile berhasil diupdate')),
        );

        Navigator.pop(context);
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Update profile gagal')),
        );
      }
    } catch (e) {
      print(e);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F3EF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 18,
                      color: AppColors.darkGreen,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Text(
                      "Profile",
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      updateProfile();
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                                  border: Border.all(
                                    color: AppColors.accent,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 46,
                                  backgroundColor: AppColors.darkGreen,
                                  // Kondisi hierarki gambar: file lokal kamera -> gambar API -> default inisial teks
                                  backgroundImage: imageFile != null
                                      ? FileImage(imageFile!)
                                      : (currentFotoPath != null && currentFotoPath!.isNotEmpty)
                                      ? NetworkImage('http://10.0.2.2:3000/uploads/$currentFotoPath') as ImageProvider
                                      : null,
                                  child: (imageFile == null && (currentFotoPath == null || currentFotoPath!.isEmpty))
                                      ? Text(
                                    nameC.text.isNotEmpty ? nameC.text[0].toUpperCase() : "U",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 34,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                      : null,
                                ),
                              ),
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (_) {
                                        return SafeArea(
                                          child: Wrap(
                                            children: [
                                              ListTile(
                                                leading: const Icon(Icons.photo),
                                                title: const Text('Galeri'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  pickImage(ImageSource.gallery);
                                                },
                                              ),
                                              ListTile(
                                                leading: const Icon(Icons.camera_alt),
                                                title: const Text('Kamera'),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  pickImage(ImageSource.camera);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: AppColors.darkGreen,
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            nameC.text,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.darkGreen,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            emailC.text,
                            style: TextStyle(
                              color: Colors.black.withOpacity(.55),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Personal Information",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 170,
                        height: 3,
                        color: AppColors.accent.withOpacity(.4),
                      ),
                    ),
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
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          updateProfile();
                        },
                        child: const Text(
                          "Update Profile",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
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
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          letterSpacing: 2,
          fontWeight: FontWeight.bold,
          color: Colors.black.withOpacity(.55),
        ),
      ),
    );
  }

  Widget _inputField(IconData icon, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(.70),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          icon: Icon(icon, color: AppColors.darkGreen),
          border: InputBorder.none,
        ),
      ),
    );
  }
}