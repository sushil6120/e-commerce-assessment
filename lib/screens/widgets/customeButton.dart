import 'package:e_commerce_ui/controller/appControllers.dart';
import 'package:flutter/material.dart';

class CustomeButton extends StatelessWidget {
  final String text;
  final double width;
  final AppController controller;
  final VoidCallback onPressed;
  final isloading;
  CustomeButton({
    super.key,
    required this.text,
    required this.width,
    required this.controller,
    required this.onPressed,
    this.isloading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(30),
          ),
        ),
        onPressed: onPressed,

        child: isloading == true
            ? CircularProgressIndicator(color: Colors.white)
            : Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
      ),
    );
  }
}
