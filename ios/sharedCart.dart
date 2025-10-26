// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:e_commerce_ui/model/cartIteModel.dart';
// import 'package:e_commerce_ui/model/productModel.dart';

// class CartController extends GetxController {
//   var cartItem = <CartItemModel>[].obs;
//   static const String CART_KEY = 'cart_items';

//   @override
//   void onInit() {
//     super.onInit();
//     loadCartFromPrefs(); // Load cart when controller initializes
//   }

//   // Load cart from SharedPreferences
//   Future<void> loadCartFromPrefs() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String? cartData = prefs.getString(CART_KEY);
      
//       if (cartData != null) {
//         final List<dynamic> decodedData = json.decode(cartData);
//         cartItem.value = decodedData
//             .map((item) => CartItemModel.fromJson(item))
//             .toList();
//         print('Cart loaded: ${cartItem.length} items');
//       }
//     } catch (e) {
//       print('Error loading cart: $e');
//     }
//   }

//   // Save cart to SharedPreferences
//   Future<void> saveCartToPrefs() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final String cartData = json.encode(
//         cartItem.map((item) => item.toJson()).toList(),
//       );
//       await prefs.setString(CART_KEY, cartData);
//       print('Cart saved: ${cartItem.length} items');
//     } catch (e) {
//       print('Error saving cart: $e');
//     }
//   }

//   // Clear cart from SharedPreferences
//   Future<void> clearCartFromPrefs() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(CART_KEY);
//       print('Cart cleared from preferences');
//     } catch (e) {
//       print('Error clearing cart: $e');
//     }
//   }

//   // Check if product is already in cart
//   bool isProductInCart(String productId) {
//     return cartItem.any((item) => item.productModel.id == productId);
//   }

//   // Get quantity of product in cart (returns 0 if not in cart)
//   int getProductQuantity(String productId) {
//     try {
//       final item = cartItem.firstWhere(
//         (item) => item.productModel.id == productId,
//       );
//       return item.quantity;
//     } catch (e) {
//       return 0;
//     }
//   }

//   // Add product to cart
//   Future<void> addToCart(ProductModel product) async {
//     var existingItem = cartItem.firstWhereOrNull(
//       (item) => item.productModel.id == product.id,
//     );

//     if (existingItem != null) {
//       // Product already in cart, increase quantity
//       existingItem.quantity++;
//       cartItem.refresh();
      
//       Get.snackbar(
//         'Already in Cart',
//         '${product.name} quantity increased to ${existingItem.quantity}',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 2),
//         backgroundColor: Colors.orange,
//         colorText: Colors.white,
//         icon: Icon(Icons.info_outline, color: Colors.white),
//       );
//     } else {
//       // New product, add to cart
//       cartItem.add(CartItemModel(productModel: product, quantity: 1));
      
//       Get.snackbar(
//         'Added to Cart',
//         '${product.name} added to cart',
//         snackPosition: SnackPosition.BOTTOM,
//         duration: Duration(seconds: 2),
//         backgroundColor: Colors.green,
//         colorText: Colors.white,
//         icon: Icon(Icons.check_circle_outline, color: Colors.white),
//       );
//     }
    
//     await saveCartToPrefs(); // Save after adding
//   }

//   // Increase quantity
//   Future<void> increaseQuatity(String productId) async {
//     var item = cartItem.firstWhere((item) => item.productModel.id == productId);
//     item.quantity++;
//     cartItem.refresh();
//     await saveCartToPrefs(); // Save after update
//   }

//   // Decrease quantity
//   Future<void> decreaseQuatity(String productId) async {
//     var item = cartItem.firstWhere((item) => item.productModel.id == productId);
//     if (item.quantity > 1) {
//       item.quantity--;
//       cartItem.refresh();
//       await saveCartToPrefs(); // Save after update
//     } else {
//       // If quantity is 1, show confirmation to remove
//       Get.defaultDialog(
//         title: 'Remove Item?',
//         middleText: 'Do you want to remove ${item.productModel.name} from cart?',
//         textConfirm: 'Yes',
//         textCancel: 'No',
//         confirmTextColor: Colors.white,
//         onConfirm: () {
//           removeProduct(productId);
//           Get.back();
//         },
//       );
//     }
//   }

//   // Remove from cart
//   Future<void> removeProduct(String productId) async {
//     cartItem.removeWhere((item) => item.productModel.id == productId);
    
//     Get.snackbar(
//       'Removed',
//       'Item removed from cart',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 2),
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       icon: Icon(Icons.delete_outline, color: Colors.white),
//     );
    
//     await saveCartToPrefs(); // Save after removal
//   }

//   // Clear entire cart
//   Future<void> clearCart() async {
//     cartItem.clear();
//     await clearCartFromPrefs();
    
//     Get.snackbar(
//       'Cart Cleared',
//       'All items removed from cart',
//       snackPosition: SnackPosition.BOTTOM,
//       duration: Duration(seconds: 2),
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//     );
//   }

//   // Get total price
//   double get totalPice {
//     return cartItem.fold(
//       0,
//       (sum, item) => sum + (item.productModel.price * item.quantity),
//     );
//   }

//   // Get total items count
//   int get totalQuatity {
//     return cartItem.fold(0, (sum, item) => sum + item.quantity);
//   }
// }

// // Add these methods to your CartItemModel class
// // If you don't have them, add them:

// /*
// class CartItemModel {
//   final ProductModel productModel;
//   int quantity;

//   CartItemModel({
//     required this.productModel,
//     this.quantity = 1,
//   });

//   // Convert to JSON for SharedPreferences
//   Map<String, dynamic> toJson() {
//     return {
//       'product': productModel.toJson(),
//       'quantity': quantity,
//     };
//   }

//   // Create from JSON
//   factory CartItemModel.fromJson(Map<String, dynamic> json) {
//     return CartItemModel(
//       productModel: ProductModel.fromJson(json['product']),
//       quantity: json['quantity'] ?? 1,
//     );
//   }
// }
// */

// // Add these methods to your ProductModel class
// // If you don't have them, add them:

// /*
// class ProductModel {
//   final String id;
//   final String name;
//   final double price;
//   final String imageUrl;
//   final String description;

//   ProductModel({
//     required this.id,
//     required this.name,
//     required this.price,
//     required this.imageUrl,
//     required this.description,
//   });

//   // Convert to JSON
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'name': name,
//       'price': price,
//       'imageUrl': imageUrl,
//       'description': description,
//     };
//   }

//   // Create from JSON
//   factory ProductModel.fromJson(Map<String, dynamic> json) {
//     return ProductModel(
//       id: json['id'],
//       name: json['name'],
//       price: json['price'].toDouble(),
//       imageUrl: json['imageUrl'],
//       description: json['description'],
//     );
//   }
// }
// */