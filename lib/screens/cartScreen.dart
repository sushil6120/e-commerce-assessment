import 'package:e_commerce_ui/controller/cartController.dart';
import 'package:e_commerce_ui/screens/widgets/cartCardWidget.dart';
import 'package:e_commerce_ui/screens/widgets/cartSummeryWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.put(CartController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
              backgroundColor: Colors.white,

        title: const Text('Shopping Cart'),
        elevation: 0,
        actions: [
        
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: cartController.refreshCart,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Obx(() {
        if (cartController.isLoading.value) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Loading cart items...'),
              ],
            ),
          );
        }

        if (cartController.cartItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 100,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add some items to get started',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: cartController.refreshCart,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reload Cart'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: cartController.refreshCart,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: cartController.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartController.cartItems[index];
                    return CartItemCard(item: item);
                  },
                ),
              ),
            ),
            const CartSummary(),
          ],
        );
      }),
    );
  }
}





