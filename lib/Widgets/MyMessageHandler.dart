import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Constants/Colors.dart';

class MyMessageHandler{
  static void showSnackBar(var scaffoldKey, String massage) {
    scaffoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: AppColor.amber,
        content: Text(
          massage,
          textAlign: TextAlign.center,
          style: GoogleFonts.nunito(
            fontSize: 20,
            fontWeight: FontWeight.w400,
            color: AppColor.black,
          ),
        ),
      ),
    );
  }
}