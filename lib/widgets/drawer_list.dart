import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/widgets/text_widget.dart';


class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final void Function()? press;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;

    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: Icon(
        icon,
        size: 18,
      ),
      title: TextWidget(
        textSize: 16,
        text: title,
        color: color,
      ),
    );
  }
}
