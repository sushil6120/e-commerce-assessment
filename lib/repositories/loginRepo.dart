import 'dart:convert';

import 'package:e_commerce_ui/utils/apiUrls.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepo {
  Future<int> loginApi(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();

    final response = await http.post(
      Uri.parse(ApiUrls.loginUrl),
      // headers: {'Content-Type': 'application/json'},
      body: {'email': username, 'password': password},
    );
    print(response.statusCode);
    if (response.statusCode == 200 || response.statusCode == 201) {
      var data = jsonDecode(response.body);
      prefs.setString('token', data['access_token']);
      return response.statusCode;
    } else {
      return response.statusCode;
    }
  }
}
