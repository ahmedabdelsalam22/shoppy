import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app_udgrade/shop/shared/style/color_manager.dart';
import 'package:shop_app_udgrade/shop/shared/style/text_manager.dart';

ThemeData appLightTheme = ThemeData(
    primarySwatch: ColorManager.primarySwatchLight,
    scaffoldBackgroundColor: ColorManager.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: ColorManager.white,
      elevation: 0.0,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
          statusBarIconBrightness: Brightness.dark),
    ),
    fontFamily: TextManager.appFont);

ThemeData appDarkTheme = ThemeData(
  primarySwatch: Colors.grey,
);
