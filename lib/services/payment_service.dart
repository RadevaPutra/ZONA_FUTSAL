import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static const String serverKey = "YOUR_SERVER_KEY"; // Dari dashboard Midtrans
  static const String baseUrl = "https://app.sandbox.midtrans.com/snap/v1/transactions";

  Future<String?> createTransaction(int amount, String orderId) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Basic ${base64Encode(utf8.encode('$serverKey:'))}',
      },
      body: jsonEncode({
        "transaction_details": {"order_id": orderId, "gross_amount": amount},
        "credit_card": {"secure": true},
        "item_details": [{"name": "Sewa Lapangan Futsal", "price": amount, "quantity": 1}]
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['redirect_url']; // Link untuk dibuka di WebView atau Browser
    }
    return null;
  }
}
