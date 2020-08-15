import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';
import 'dart:convert';
import '../models/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class OrdersProvider with ChangeNotifier {
  static String baseUrl = 'https://shop-app-2170f.firebaseio.com';

  List<OrderItem> _items = [];

  List<OrderItem> get orders {
    return [..._items];
  }

  Future<void> fetchAndSetOrders() async {
    try {
      http.Response response = await http.get('$baseUrl/orders.json');
      final fetchedproducts =
          json.decode(response.body) as Map<String, dynamic>;

      print(fetchedproducts);

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    try {
      final timestamp = DateTime.now();
      http.Response response = await http.post(
        '$baseUrl/orders.json',
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        }),
      );

      Map<String, dynamic> savedOrder = json.decode(response.body);

      final newOrder = OrderItem(
        id: savedOrder['name'],
        amount: total,
        products: cartProducts,
        dateTime: timestamp,
      );
      _items.insert(0, newOrder);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  void clearOrders() {
    _items = [];
    notifyListeners();
  }
}
