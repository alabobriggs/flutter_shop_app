import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class AuthProvider with ChangeNotifier {
  static const String authUrl = "https://identitytoolkit.googleapis.com/v1";
  static final String apiKey = DotEnv().env['FIREBASE_API_KEY'];

  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        token != null) {
      return token;
    }
    return null;
  }

  Future<void> _authenticate({
    String email,
    String password,
    String urlSegment,
  }) async {
    try {
      final http.Response response = await http.post(
        '$authUrl/accounts:$urlSegment?key=$apiKey',
        body: json.encode({
          "email": email,
          "password": password,
          "returnSecureToken": true,
        }),
      );

      final responseData = json.decode(response.body);

      print(json.decode(response.body));

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (err) {
      throw err;
    }
  }

  Future<void> signUp({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signUp",
    );
  }

  Future<void> login({String email, String password}) async {
    return _authenticate(
      email: email,
      password: password,
      urlSegment: "signInWithPassword",
    );
  }
}
