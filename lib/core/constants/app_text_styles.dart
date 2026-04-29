import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String dmSans = 'DM Sans';
  static const String dmMono = 'DM Mono';

  static const TextStyle display = TextStyle(
    fontFamily: dmSans,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.4,
  );

  static const TextStyle headline = TextStyle(
    fontFamily: dmSans,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    fontFamily: dmSans,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: AppColors.grey3,
    height: 1.5,
  );

  static const TextStyle caption = TextStyle(
    fontFamily: dmMono,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.grey4,
    height: 1.4,
  );

  static const TextStyle label = TextStyle(
    fontFamily: dmMono,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.grey3,
    height: 1.4,
  );
}
