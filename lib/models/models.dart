class Field {
  final String id;
  final String name;
  final String type;
  final String category;
  final int pricePerHour;
  final String image;
  final double rating;
  final bool isAvailable;
  final String location;
  final String operationalHours;
  final double latitude;
  final double longitude;

  Field({
    required this.id,
    required this.name,
    required this.type,
    this.category = 'Indoor',
    required this.pricePerHour,
    required this.image,
    required this.rating,
    this.isAvailable = true,
    this.location = 'Lokasi Terdekat',
    this.operationalHours = '08:00 - 22:00',
    required this.latitude,
    required this.longitude,
  });
}

class Booking {
  final String bookingCode;
  final String username; //
  final Field field;
  final String subField;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationHours;
  final int totalPrice;
  final int discountAmount;
  final String? voucherCode;
  final String status;

  Booking({
    required this.bookingCode,
    required this.username,
    required this.field,
    required this.subField,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    this.discountAmount = 0,
    this.voucherCode,
    this.status = 'Aktif',
  });
}

class AppData {
  // 👈 SIMULASI LOGIN: Ganti 'Anom' jadi 'Ayu' di sini untuk ngetes perpindahan akun!
  static String currentUser = 'Anom';

  static List<Field> fields = [
    Field(
      id: '1',
      name: 'Telkom University Futsal',
      type: 'Vinyl Court',
      pricePerHour: 45000,
      image: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=500',
      rating: 4.9,
      location: 'Bojongsoang, Bandung',
      latitude: -6.9740,
      longitude: 107.6303,
    ),
    Field(
      id: '2',
      name: 'Podomoro Futsal Hub',
      type: 'Synthetic Grass',
      pricePerHour: 65000,
      image: 'https://images.unsplash.com/photo-1529900948632-58674ba79291?w=500',
      rating: 4.7,
      location: 'Bojongsoang, Bandung',
      latitude: -6.9800,
      longitude: 107.6350,
    ),
    Field(
      id: '3',
      name: 'Bojongsoang Sport Center',
      type: 'Interlocking',
      pricePerHour: 55000,
      image: 'https://images.unsplash.com/photo-1518605368461-1ee7c68154a1?w=500',
      rating: 4.5,
      location: 'Bojongsoang, Bandung',
      latitude: -6.9700,
      longitude: 107.6400,
    ),
    Field(
      id: '4',
      name: 'Sintra Futsal Dago',
      type: 'Vinyl Court',
      pricePerHour: 50000,
      image: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=500',
      rating: 4.8,
      location: 'Dago, Bandung',
      latitude: -6.8797,
      longitude: 107.6186,
    ),
    Field(
      id: '5',
      name: 'Z-Futsal Antapani',
      type: 'Synthetic Grass',
      pricePerHour: 60000,
      image: 'https://images.unsplash.com/photo-1529900948632-58674ba79291?w=500',
      rating: 4.5,
      location: 'Antapani, Bandung',
      latitude: -6.9147,
      longitude: 107.6624,
    ),
    Field(
      id: '6',
      name: 'Champion Arena Buah Batu',
      type: 'Interlocking',
      category: 'Outdoor',
      pricePerHour: 80000,
      image: 'https://images.unsplash.com/photo-1518605368461-1ee7c68154a1?w=500',
      rating: 4.9,
      location: 'Buah Batu, Bandung',
      latitude: -6.9475,
      longitude: 107.6413,
    ),
  ];

  static List<String> timeSlots = [
    '08:00 - 10:00',
    '10:00 - 12:00',
    '12:00 - 14:00',
    '14:00 - 16:00',
    '16:00 - 18:00',
    '18:00 - 20:00',
    '20:00 - 22:00'
  ];

  static List<String> bookedSlots = [];
  static Map<String, List<String>> bookedSlotsByDate = {};
  static List<Booking> recentBookings = [];

}
