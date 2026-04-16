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
  });
}

class Booking {
  final String bookingCode;
  final Field field;
  final String subField;
  final DateTime date;
  final String startTime;
  final String endTime;
  final int durationHours;
  final int totalPrice;
  final String status;

  Booking({
    required this.bookingCode,
    required this.field,
    required this.subField,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.durationHours,
    required this.totalPrice,
    this.status = 'Aktif',
  });
}

class AppData {
  static List<Field> fields = [
    Field(
      id: '1',
      name: 'Sintra Futsal Dago',
      type: 'Vinyl Court',
      pricePerHour: 50000,
      image: 'https://images.unsplash.com/photo-1574629810360-7efbbe195018?w=500',
      rating: 4.8,
      location: 'Lokasi Terdekat',
    ),
    Field(
      id: '2',
      name: 'Z-Futsal Antapani',
      type: 'Synthetic Grass',
      pricePerHour: 60000,
      image: 'https://images.unsplash.com/photo-1529900948632-58674ba79291?w=500',
      rating: 4.5,
      location: 'Lokasi Terdekat',
    ),
    Field(
      id: '3',
      name: 'Champion Arena Buah Batu',
      type: 'Interlocking',
      category: 'Outdoor',
      pricePerHour: 80000,
      image: 'https://images.unsplash.com/photo-1518605368461-1ee7c68154a1?w=500',
      rating: 4.9,
      location: 'Lokasi Terdekat',
    ),
    Field(
      id: '4',
      name: 'Gor Futsal Sudirman',
      type: 'Vinyl Court',
      pricePerHour: 55000,
      image: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500',
      rating: 4.6,
      location: 'Jakarta Pusat',
    ),
  ];

  static List<String> timeSlots = [
    '08:00', '09:00', '10:00', '11:00', '13:00', 
    '14:00', '15:00', '16:00', '19:00', '20:00'
  ];

  static List<String> bookedSlots = ['09:00', '16:00'];

  static List<Booking> recentBookings = [];
}