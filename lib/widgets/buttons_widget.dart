import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.backgroundColor, required this.press,
  }) : super(key: key);
  final void Function()? press;
  final String text;
  final IconData icon;
  final Color backgroundColor;
  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: EdgeInsets.symmetric(
          horizontal: dimensions.getScreenW(24),
          vertical: dimensions.getScreenW(16) / (Responsive.isDesktop(context) ? 1 : 2),
        ),
      ),
      onPressed: press,
      icon: Icon(
        icon,
        size: dimensions.getScreenW(20),
      ),
      label: Text(text),
    );
  }
}
