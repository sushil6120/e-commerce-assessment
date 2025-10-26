import 'dart:convert';

import 'package:e_commerce_ui/models/cartItems.dart';
import 'package:http/http.dart' as http;

class CartApiService {
  static const String baseUrl = 'https://dummyjson.com';

  Future<List<CartItem>> getCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/carts/1'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final products = data['products'] as List;
        return products.map((item) => CartItem.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      throw Exception('Error fetching cart: $e');
    }
  }

  Future<bool> updateCart(List<CartItem> items) async {
    try {
      final products = items.map((item) => {
        'id': item.id,
        'quantity': item.quantity,
      }).toList();

      final response = await http.put(
        Uri.parse('$baseUrl/carts/1'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'merge': false,
          'products': products,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating cart: $e');
      return false;
    }
  }

  Future<bool> deleteCart() async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/carts/1'),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting cart: $e');
      return false;
    }
  }

  Future<bool> addToCart(int productId, int quantity) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/carts/add'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': 1,
          'products': [
            {'id': productId, 'quantity': quantity}
          ]
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error adding to cart: $e');
      return false;
    }
  }
}