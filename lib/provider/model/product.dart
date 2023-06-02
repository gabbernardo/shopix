import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void _setFavValue(bool newValue){
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleStatusFavorite(String token, String userId) async {
    final currentStatus = isFavorite;
    /// using '!' inverts the value of it
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if(response.statusCode >= 400){
        _setFavValue(currentStatus);
        throw const HttpException('Cannot add to favorites!');
      }
    } catch (error) {
      _setFavValue(currentStatus);
    }
  }
}
