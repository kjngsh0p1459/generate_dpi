import 'package:flutter/material.dart';
import 'package:resources/src/dimens/app_dimen.dart';
import 'package:resources/src/dimens/dimens.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();
  static const _defaultLetterSpacing = 0.03;

  static const _baseTextStyle = TextStyle(
    letterSpacing: _defaultLetterSpacing,
  );

  static TextStyle s14w400Primary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize: Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.primaryTextColor,
      ));

  static TextStyle s14w400Secondary({
    double? tablet,
    double? ultraTablet,
  }) =>
      _baseTextStyle.merge(TextStyle(
        fontSize: Dimens.d14.responsive(tablet: tablet, ultraTablet: ultraTablet),
        fontWeight: FontWeight.w400,
        color: AppColors.current.secondaryTextColor,
      ));
}
