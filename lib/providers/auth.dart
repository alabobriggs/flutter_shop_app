import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  static const String authUrl = "https://identitytoolkit.googleapis.com/v1";
  static final String apiKey = DotEnv().env['FIREBASE_API_KEY'];

  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> signUp({String email, String password}) async {
    final http.Response response = await http.post(
      '$authUrl/accounts:signUp?key=$apiKey',
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    final extractedValue = json.decode(response.body);

    print(extractedValue);
  }
}
