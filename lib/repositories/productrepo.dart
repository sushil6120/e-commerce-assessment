import 'dart:convert';

import 'package:e_commerce_ui/models/productsModel.dart';
import 'package:e_commerce_ui/utils/apiUrls.dart';
import 'package:http/http.dart' as http;

class ProductRepo {
  Future<ProductsModel> productsApis() async {
    final response = await http.get(Uri.parse(ApiUrls.productApi));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      return ProductsModel.fromJson(data);
    } else {
      throw Exception('Failed to load products');
    }
  }

  
}
