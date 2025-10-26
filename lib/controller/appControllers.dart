import 'package:e_commerce_ui/models/productsModel.dart';
import 'package:e_commerce_ui/repositories/loginRepo.dart';
import 'package:e_commerce_ui/repositories/productrepo.dart';
import 'package:e_commerce_ui/screens/homeScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart'
    show SharedPreferences;

class AppController extends GetxController {
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();
  LoginRepo loginRepo = LoginRepo();
  ProductRepo productRepo = ProductRepo();
  var quantitys = 1.obs;

  var productModel = <Products>[].obs;
  var isLoading = false.obs;
  var isLoadings = false.obs;

  Future<void> login(String username, String password) async {
    try {
      isLoadings.value = true;
      int statusCode = await loginRepo.loginApi(username, password);
      if (statusCode == 200 || statusCode == 201) {
        print('Login successful');
        Get.to(HomeScreen());
        isLoadings.value = false;
      } else {
        print('Login failed with status code: $statusCode');
        isLoadings.value = false;
      }
    } catch (e) {
      print('An error occurred: $e');
      isLoadings.value = false;
    }
  }

  Future<void> fetchProducts() async {
    try {
      productModel.clear();
      isLoading.value = true;
      var products = await productRepo.productsApis();
      productModel.addAll(products.products!);
      isLoading.value = false;
    } catch (e) {
      print('An error occurred while fetching products: $e');
      isLoading.value = false;
    }
  }

  
}
