import 'package:flutter/material.dart';

//import constants
import 'package:grow_app/constants/colors.dart';
import 'package:grow_app/constants/fonts.dart';

void showSnackBar(context, text, category) {
  final snackBar = SnackBar(
    content: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon((category == "error") ? Icons.error_outline : Icons.verified,
            size: 24, color: purpleDark),
        SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: 'Poppins',
                color: black,
                fontWeight: FontWeight.w600,
                fontSize: suggestion12),
          ),
        ),
      ],
    ),
    backgroundColor: white,
    duration: Duration(seconds: 3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    margin: EdgeInsets.symmetric(horizontal: 24),
    behavior: SnackBarBehavior.floating,
    elevation: 0,
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}
