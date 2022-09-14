import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';

void showCustomSnackBar(String message, BuildContext context, {bool isError = true}) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: isError ? Colors.red : Colors.green,
    content: Text(message),
  ));
}
