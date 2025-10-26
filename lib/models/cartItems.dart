

import 'package:e_commerce_ui/models/productsModel.dart';

class CartItem {
  final int id;
  final String title;
  final String thumbnail;
  final double price;
  int quantity;
  final double discountPercentage;

  CartItem({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.price,
    required this.quantity,
    required this.discountPercentage,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      title: json['title'],
      thumbnail: json['thumbnail'],
      price: json['price'].toDouble(),
      quantity: json['quantity'] ?? 1,
      discountPercentage: json['discountPercentage']?.toDouble() ?? 0.0,
    );
  }

  factory CartItem.fromProduct(Products product, int quantity) {
    return CartItem(
      id: product.id??0,
      title: product.title!,
      thumbnail: product.thumbnail!,
      price: product.price!,
      quantity: quantity,
      discountPercentage: 10,
    );
  }

  double get totalPrice => price * quantity;
  double get discountedPrice => price - (price * discountPercentage / 100);
  double get totalDiscountedPrice => discountedPrice * quantity;
}