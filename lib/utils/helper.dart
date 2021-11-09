import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Text getBoldText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color,
    )),
  );
}

Text getNormalText(String text, double fontSize, Color color) {
  return Text(
    text,
    style: GoogleFonts.varelaRound(
        textStyle: TextStyle(
      fontSize: fontSize,
      color: color,
    )),
  );
}

class Config {
  static const String oneSignalAppId = 'f80b1159-88c2-48e5-999a-92d1ea70526a';
}

bool isAdmin(String val) {
  List<String> admin = [
    '+918821093345',
    '+919340133342',
    '+918888888888',
  ];
  bool isAdmin;
  admin.contains(val) ? isAdmin = true : isAdmin = false;
  return isAdmin;
}

bool isInThreeKm(String area) {
  List<String> threeKm = [
    'Bharhut nagar',
    'Mukhtiyar Ganj',
    'Civil Line',
    'Pannilal Chowk',
    'Jeevan Jyoti colony',
    'Mandakini Vihar Colony',
    'Rajendra Nagar',
    'Jawahar Nagar',
    'Umri',
    'Sangram Colony',
    'Jagat Dev Talab',
    'Raghuraj Nagar',
    'Gaushala Chowk',
    'Bhandavgarh colony',
  ];
  return threeKm.contains(area);
}
