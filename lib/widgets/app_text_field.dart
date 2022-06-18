import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextInputType keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final String hint;
  final int maxLength;
  final int maxLines;
  final bool enabled ;


  AppTextField(
      {this.keyboardType = TextInputType.text,
      required this.controller,
      this.obscureText = false,
        this.maxLength = 30,
        this.maxLines = 1,
        this.enabled = true ,
      required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      enabled: enabled,
      keyboardType: keyboardType,
      controller: controller,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: hint,
        counterText: '',
        enabledBorder: border,
        focusedBorder: border,
        disabledBorder: borderDisable,
      ),
    );
  }

  OutlineInputBorder get border => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.black,
        ),
      );

  OutlineInputBorder get borderDisable => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      );
}
