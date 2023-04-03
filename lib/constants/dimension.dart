import 'package:flutter/material.dart';

class AppDimensions {
  late BuildContext context;
  double get getScreenWidth => MediaQuery.of(context).size.width;
  double get getScreenHeight => MediaQuery.of(context).size.height;
  AppDimensions(this.context);
  double getScreenH(double inputHeight) {
    double x = getScreenWidth / inputHeight;
    return getScreenWidth / x;
  }

  double getScreenW(double inputWidth) {
    double x = getScreenWidth / inputWidth;
    return getScreenWidth / x;
  }
}
