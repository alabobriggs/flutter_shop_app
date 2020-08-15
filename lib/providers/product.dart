import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductModelProvider with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductModelProvider({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavouriteStatus() async {
    final oldStatus = isFavourite;
    _setFavValue(!isFavourite);

    try {
      final http.Response response = await http.patch(
        'https://shop-app-2170f.firebaseio.com/products/$id.json',
        body: json.encode({
          'isFavourite': !isFavourite,
        }),
      );

      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (err) {
      _setFavValue(oldStatus);
    }
  }
}
