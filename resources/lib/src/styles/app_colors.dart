import 'package:flutter/material.dart';
import 'package:resources/resources.dart';

class AppColors {
  const AppColors({
    required this.primaryColor,
    required this.secondaryColor,
    required this.primaryTextColor,
    required this.secondaryTextColor,
    required this.primaryGradient,
  });

  static late AppColors current;

  final Color primaryColor;
  final Color secondaryColor;
  final Color primaryTextColor;
  final Color secondaryTextColor;

  final LinearGradient primaryGradient;

  static AppColors of(BuildContext context) {
    final appColor = Theme.of(context).appColor;

    current = appColor;

    return current;
  }

  static const defaultAppColor = AppColors(
    primaryColor: Color.fromARGB(255, 166, 168, 254),
    secondaryColor: Color.fromARGB(255, 62, 62, 70),
    primaryTextColor: Color.fromARGB(255, 62, 62, 70),
    secondaryTextColor: Color.fromARGB(255, 166, 168, 254),
    primaryGradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
  );

  static const darkThemeColor = AppColors(
    primaryColor: Color.fromARGB(255, 62, 62, 70),
    secondaryColor: Color.fromARGB(255, 166, 168, 254),
    primaryTextColor: Color.fromARGB(255, 166, 168, 254),
    secondaryTextColor: Color.fromARGB(255, 62, 62, 70),
    primaryGradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0xFFFE6C30)]),
  );

  AppColors copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? primaryTextColor,
    Color? secondaryTextColor,
    LinearGradient? primaryGradient,
  }) {
    return AppColors(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      primaryTextColor: primaryTextColor ?? this.primaryTextColor,
      secondaryTextColor: secondaryTextColor ?? this.secondaryTextColor,
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }
}
