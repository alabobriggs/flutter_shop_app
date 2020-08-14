import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './product.dart';

class ProductsProvider with ChangeNotifier {
  static String baseUrl = 'https://shop-app-2170f.firebaseio.com';

  List<ProductModelProvider> _items = [];
  List<ProductModelProvider> get items {
    return [..._items];
  }

  List<ProductModelProvider> get favouriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  ProductModelProvider findById(String productId) {
    return _items.firstWhere((prod) => prod.id == productId);
  }

  Future<void> fetchAndSetProducts() async {
    try {
      http.Response response = await http.get('$baseUrl/products.json');
      final fetchedproducts =
          json.decode(response.body) as Map<String, dynamic>;
      final List<ProductModelProvider> loadedProducts = [];
      fetchedproducts.forEach(
        (prodId, prodData) {
          loadedProducts.add(ProductModelProvider(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ));
        },
      );

      _items = loadedProducts;

      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future<void> addProduct(ProductModelProvider product) async {
    try {
      http.Response response = await http.post(
        '$baseUrl/products.json',
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavourite': product.isFavourite,
        }),
      );

      Map<String, dynamic> savedProduct = json.decode(response.body);

      final newProduct = ProductModelProvider(
        id: savedProduct['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateProduct({
    String id,
    ProductModelProvider newProduct,
  }) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    await http.patch(
      '$baseUrl/products/$id.json',
      body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }),
    );

    if (prodIndex > 0) {
      _items[prodIndex] = newProduct;

      notifyListeners();
    } else {}
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);

    notifyListeners();
  }
}
