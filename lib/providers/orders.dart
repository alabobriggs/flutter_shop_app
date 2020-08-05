import 'package:flutter/foundation.dart';
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
  List<OrderItem> _items = [];

  List<OrderItem> get orders {
    return [..._items];
  }

  void addOrder(List<CartItem> cartProducts, double total) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  void clearOrders() {
    _items = [];
    notifyListeners();
  }
}
