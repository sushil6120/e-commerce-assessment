import 'package:e_commerce_ui/controller/appControllers.dart';
import 'package:e_commerce_ui/screens/widgets/customeButton.dart'
    show CustomeButton;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final controller = Get.put(AppController());
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formkey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * .1),
              Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 16),

              Center(
                child: Text(
                  'Welcome Back!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: height * .06),

              TextFormField(
                controller: controller.userNameController,
                decoration: InputDecoration(
                  hintText: 'User Name',
                  prefixIcon: Icon(Icons.person, color: Colors.grey[600]),
                  hintStyle: TextStyle(fontSize: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),

              TextFormField(
                controller: controller.passwordController,
                decoration: InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.password, color: Colors.grey[600]),
                  hintStyle: TextStyle(fontSize: 14),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),

              SizedBox(height: 24),
              Obx(
                () => CustomeButton(
                  text: "Login",
                  width: width,
                  controller: controller,
                  isloading: controller.isLoadings.value,
                  onPressed: () {
                    if (formkey.currentState!.validate()) {
                      controller.login(
                        controller.userNameController.text,
                        controller.passwordController.text,
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
