import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color backgroundUp = Color(0xFF2E73D5);
  static const Color btnColor = Color(0xFF2B75D8);
  static const Color backgroundDown = Color(0xFFD0CCD5);
  static const Color mist = Color(0xFF999999);
  static const Color acceptedMed = Color(0xFFC3DC9B);
  static const Color acceptedFont = Color(0xFFC3DC9B);
  static const Color todayBack = Color(0xFFFFDADB);
  static const Color todayFont = Color(0xFF470001);
  static const Color backCircleColor = Color.fromRGBO(180, 211, 255, 0.2);
  static Color borderColor  = Colors.grey.shade400;
  static const Color defaultText = Colors.black;
  static const Color pastText = Color(0xFF9E9E9E);
  static const Color defaultBackground = Colors.white;
  static const Color appGrey = Color(0xFFF0F6FF);
}

class AppTextStyles {
  static final TextStyle headline = GoogleFonts.montserratAlternates(
    fontSize: 25,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );

  static final TextStyle screenHeadline = GoogleFonts.montserratAlternates(
    fontSize: 35,
    fontWeight: FontWeight.w900,
  );

  static final TextStyle body = GoogleFonts.montserratAlternates(
    fontSize: 25,
    color: Colors.white,
  );

  static final TextStyle menuHeadline = GoogleFonts.montserratAlternates(
      fontSize: 28,
      fontWeight: FontWeight.w900
  );

  static final TextStyle menuItem = GoogleFonts.montserratAlternates(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle contentText = GoogleFonts.montserratAlternates(
      fontSize: 15,
      fontWeight: FontWeight.w600
  );
  static final TextStyle cardHeadline = GoogleFonts.montserratAlternates(
      fontSize: 16,
      fontWeight: FontWeight.w700
  );

  static final TextStyle contentTextGrey = GoogleFonts.montserratAlternates(
      fontSize: 15,
      fontWeight: FontWeight.w600,
    color: Colors.grey
  );

  static final TextStyle notificationGrey = GoogleFonts.montserratAlternates(
      fontSize: 18,
      color: Colors.grey
  );
  static final TextStyle tagText = GoogleFonts.montserratAlternates(
      fontSize: 13,
      fontWeight: FontWeight.w600,


  );
  static final TextStyle commonText = GoogleFonts.montserratAlternates(
      fontSize: 16,
      fontWeight: FontWeight.w500
  );


}