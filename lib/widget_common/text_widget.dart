import 'package:flutter/material.dart';

Widget textWidget({
  required String text,
  required double fontSize,
  required FontWeight fontWeight,
  required String fontFamily,
  required Color color,
  //required TextAlign textAlign
}) {
  return Text(
    text,
    style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color),
    //style: GoogleFonts.poppins(fontSize: fontSize,fontWeight: fontWeight,color: color),
  );
}
