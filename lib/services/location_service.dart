import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<Position?> getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );
  }

  // Logika menghitung jarak (KM)
  double calculateDistance(double userLat, double userLon, double fieldLat, double fieldLon) {
    return Geolocator.distanceBetween(userLat, userLon, fieldLat, fieldLon) / 1000;
  }
}
