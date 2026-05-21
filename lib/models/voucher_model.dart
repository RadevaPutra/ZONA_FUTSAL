class Voucher {
  final String code;
  final String title;
  final String description;
  final VoucherType type;
  final double discountValue; // persen jika type=percent, nominal jika type=flat
  final int minDurationHours; // minimal jam sewa
  final int? maxDiscount; // batas maksimal diskon (untuk tipe persen)
  final DateTime expiredAt;
  final String iconEmoji;
  final bool isUsed;

  const Voucher({
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.discountValue,
    required this.minDurationHours,
    this.maxDiscount,
    required this.expiredAt,
    required this.iconEmoji,
    this.isUsed = false,
  });

  bool get isExpired => DateTime.now().isAfter(expiredAt);

  bool get isValid => !isExpired && !isUsed;

  /// Hitung nilai diskon berdasarkan total harga
  int calculateDiscount(int totalPrice) {
    if (!isValid) return 0;
    if (type == VoucherType.percent) {
      final disc = (totalPrice * discountValue / 100).round();
      if (maxDiscount != null && disc > maxDiscount!) return maxDiscount!;
      return disc;
    } else {
      return discountValue.toInt();
    }
  }

  String get discountLabel {
    if (type == VoucherType.percent) {
      return '${discountValue.toInt()}% OFF';
    } else {
      return 'Rp ${_formatPrice(discountValue.toInt())} OFF';
    }
  }

  static String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
  }
}

enum VoucherType { percent, flat }

class VoucherData {
  static List<Voucher> availableVouchers = [
    Voucher(
      code: 'MAIN2JAM',
      title: 'Diskon Sewa 2 Jam+',
      description: 'Hemat 15% untuk booking lebih dari 2 jam',
      type: VoucherType.percent,
      discountValue: 15,
      minDurationHours: 2,
      maxDiscount: 30000,
      expiredAt: DateTime.now().add(const Duration(days: 30)),
      iconEmoji: '⚡',
    ),
    Voucher(
      code: 'FUTSAL20K',
      title: 'Cashback Rp 20.000',
      description: 'Potongan langsung Rp 20.000 untuk sewa lebih dari 2 jam',
      type: VoucherType.flat,
      discountValue: 20000,
      minDurationHours: 2,
      expiredAt: DateTime.now().add(const Duration(days: 14)),
      iconEmoji: '💰',
    ),
    Voucher(
      code: 'WEEKEND25',
      title: 'Weekend Special 25%',
      description: 'Diskon 25% khusus akhir pekan, min. booking 2 jam',
      type: VoucherType.percent,
      discountValue: 25,
      minDurationHours: 2,
      maxDiscount: 50000,
      expiredAt: DateTime.now().add(const Duration(days: 7)),
      iconEmoji: '🎉',
    ),
    Voucher(
      code: 'NEWUSER',
      title: 'Promo Member Baru',
      description: 'Diskon 10% untuk pengguna baru, min. 2 jam',
      type: VoucherType.percent,
      discountValue: 10,
      minDurationHours: 2,
      maxDiscount: 15000,
      expiredAt: DateTime.now().add(const Duration(days: 60)),
      iconEmoji: '🎁',
    ),
  ];

  static Voucher? findByCode(String code) {
    try {
      return availableVouchers.firstWhere(
        (v) => v.code.toUpperCase() == code.toUpperCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
