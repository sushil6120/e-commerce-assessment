import 'package:e_commerce_ui/models/cartItems.dart';
import 'package:e_commerce_ui/models/productsModel.dart';
import 'package:e_commerce_ui/repositories/cartServices.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  final CartApiService _apiService = CartApiService();
  
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble discountedTotal = 0.0.obs;
  final RxInt totalItems = 0.obs;
  final RxDouble totalSavings = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      isLoading.value = true;
      final items = await _apiService.getCartItems();
      cartItems.value = items;
      calculateTotal();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart items: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> increaseQuantity(int itemId) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        cartItems[index].quantity++;
        cartItems.refresh();
        calculateTotal();
        
        final success = await _apiService.updateCart(cartItems);
        
        if (!success) {
          cartItems[index].quantity--;
          cartItems.refresh();
          calculateTotal();
          throw Exception('Update failed');
        }
        
        Get.snackbar(
          'Updated',
          'Quantity increased',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> decreaseQuantity(int itemId) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1 && cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
        calculateTotal();
        
        final success = await _apiService.updateCart(cartItems);
        
        if (!success) {
          cartItems[index].quantity++;
          cartItems.refresh();
          calculateTotal();
          throw Exception('Update failed');
        }
        
        Get.snackbar(
          'Updated',
          'Quantity decreased',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update quantity',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      final removedItem = cartItems[index];
      
      cartItems.removeAt(index);
      calculateTotal();
      
      final success = await _apiService.updateCart(cartItems);
      
      if (!success) {
        cartItems.insert(index, removedItem);
        calculateTotal();
        throw Exception('Remove failed');
      }
      
      Get.snackbar(
        'Removed',
        '${removedItem.title} removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> removeAll() async {
    if (cartItems.isEmpty) return;
    
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Are you sure you want to remove all items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
    
    if (confirmed != true) return;
    
    try {
      final oldItems = List<CartItem>.from(cartItems);
      
      cartItems.clear();
      calculateTotal();
      
      final success = await _apiService.deleteCart();
      
      if (!success) {
        cartItems.value = oldItems;
        calculateTotal();
        throw Exception('Clear cart failed');
      }
      
      Get.snackbar(
        'Cart Cleared',
        'All items removed from cart',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

void addToCart(Products product) {
    final index = cartItems.indexWhere((item) => item.id == product.id);
    
    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem.fromProduct(product, 1));
    }
    
    calculateTotal();
    
    Get.snackbar(
      'Added to Cart',
      '${product.title} added successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }
  void calculateTotal() {
    totalAmount.value = cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
    discountedTotal.value = cartItems.fold(0.0, (sum, item) => sum + item.totalDiscountedPrice);
    totalItems.value = cartItems.fold(0, (sum, item) => sum + item.quantity);
    totalSavings.value = totalAmount.value - discountedTotal.value;
  }

  Future<void> refreshCart() async {
    await fetchCartItems();
  }
}