// import 'package:e_commerce_ui/model/cartIteModel.dart';
// import 'package:e_commerce_ui/model/productModel.dart';
// import 'package:get/get.dart';

// class CartController extends GetxController {
//   var cartItem = <CartItemModel>[].obs;

//   void addtToCart(ProductModel product) {
//     var exestingItem = cartItem.firstWhereOrNull(
//       (item) => item.productModel.id == product.id,
//     );
//     if (exestingItem != null) {
//       exestingItem.quantity++;
//       cartItem.refresh();
//     } else {
//       cartItem.add(CartItemModel(productModel: product));
//       cartItem.refresh();
//     }
//   }

//   void increaseQuatity(String productId) {
//     var item = cartItem.firstWhere(
//       (element) => element.productModel.id == productId,
//     );
//     item.quantity++;
//     cartItem.refresh();
//   }

//   void decreaseQuatity(String productId) {
//     var item = cartItem.firstWhere(
//       (element) => element.productModel.id == productId,
//     );
//     item.quantity--;
//     cartItem.refresh();
//   }

//   void removeProduct(String productId) {
//     cartItem.removeWhere((element) => element.productModel.id == productId);
//     cartItem.refresh();
//   }

//   double get totalPice {
//     return cartItem.fold(
//       0,
//       (previousValue, element) =>
//           previousValue + (element.productModel.price * element.quantity),
//     );
//   }

//   int get totalQuatity {
//     return cartItem.fold(
//       0,
//       (previousValue, element) => previousValue + element.quantity,
//     );
//   }
// }
