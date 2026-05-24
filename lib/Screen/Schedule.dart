import 'package:flutter/material.dart';
import '../services/location_service.dart';
import 'package:geolocator/geolocator.dart'; // Untuk tipe data Position
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'booking.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  bool isNearMeActive = false;
  bool isLoadingLocation = false;
  String searchQuery = '';
  List<Field> filteredFields = AppData.fields.where((f) => f.location.toLowerCase().contains("bandung")).toList();

  void _filterFields() {
    setState(() {
      Iterable<Field> result = AppData.fields;

      if (isNearMeActive) {
        final nearMeNames = [
          'Telkom University Futsal',
          'Podomoro Futsal Hub',
          'Bojongsoang Sport Center',
          'Champion Arena Buah Batu'
        ];
        result = result.where((f) => nearMeNames.contains(f.name));
      } else {
        result = result.where((f) => f.location.toLowerCase().contains("bandung"));
      }

      if (searchQuery.isNotEmpty) {
        result = result.where((f) => f.name.toLowerCase().contains(searchQuery.toLowerCase()));
      }

      filteredFields = result.toList();
    });
  }

 void _toggleNearMe() async {
    if (isNearMeActive) {
      setState(() {
        isNearMeActive = false;
      });
      _filterFields(); 
      return;
    }

    setState(() {
      isLoadingLocation = true;
    });

    LocationService locationService = LocationService();
    Position? position = await locationService.getCurrentPosition();

    if (position == null) {
      setState(() {
        isLoadingLocation = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mendapatkan lokasi. Cek GPS/Izin aplikasi.')),
      );
      return;
    }

    List<Field> nearMeResult = [];
    
    for (var field in AppData.fields) {
      double distanceKm = locationService.calculateDistance(
        position.latitude,
        position.longitude,
        field.latitude,   // HARUS ADA di models.dart
        field.longitude,  // HARUS ADA di models.dart
      );

      if (distanceKm >= 5.0 && distanceKm <= 7.0) {
        nearMeResult.add(field);
      }
    }

    setState(() {
      isNearMeActive = true;
      filteredFields = nearMeResult;
      isLoadingLocation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E0D),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(child: _buildSearchBar()),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _toggleNearMe,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: isNearMeActive ? AppColors.accent : Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.near_me, 
                            size: 18, 
                            color: isNearMeActive ? Colors.black : Colors.white),
                        const SizedBox(width: 8),
                        Text("Near Me", 
                            style: TextStyle(
                              color: isNearMeActive ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoadingLocation 
              ? const Center(child: CircularProgressIndicator(color: AppColors.accent))
              : filteredFields.isEmpty 
                ? _buildEmptyState() 
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: filteredFields.length,
                    itemBuilder: (context, index) {
                      return _buildVerticalFieldCard(filteredFields[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Cari Lapangan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      backgroundColor: const Color(0xFF0F3D2E),
      iconTheme: const IconThemeData(color: Colors.white),
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) {
        searchQuery = value;
        _filterFields();
      },
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: "Cari nama lapangan...",
        hintStyle: const TextStyle(color: Colors.white38),
        prefixIcon: const Icon(Icons.search, color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded, color: Colors.white24, size: 64),
          const SizedBox(height: 16),
          const Text("Tidak ada lapangan di sekitar", style: TextStyle(color: Colors.white38)),
        ],
      ),
    );
  }
  Widget _buildVerticalFieldCard(Field field) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingScreen(field: field),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.sports_soccer, color: AppColors.accent, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(field.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.white38, size: 12),
                      const SizedBox(width: 4),
                      Text(field.location, style: const TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("Tersedia: ${field.operationalHours}", 
                      style: const TextStyle(color: AppColors.accent, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
