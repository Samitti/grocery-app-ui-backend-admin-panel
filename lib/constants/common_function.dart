import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gecoory_web_panel/widgets/text_widget.dart';

class CommonFunctions {
  static navigateTo({required BuildContext ctx, required String routeName}) {
    Navigator.pushNamed(ctx, routeName);
  }

  static Future<void> warningDialog({
    required String title,
    required String subtitle,
    required Function fct,
    required BuildContext context,
  }) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
            const SizedBox(
              width: 8,
            ),
            Text(title),
          ]),
          content: Text(subtitle),
          actions: [
            TextButton(
              onPressed: () {
                if (Navigator.canPop(context)) {
                  Navigator.pop(context);
                }
              },
              child: const TextWidget(
                color: Colors.cyan,
                text: 'Cancel',
                textSize: 18,
              ),
            ),
            TextButton(
              onPressed: () {
                fct();
              },
              child: const TextWidget(
                color: Colors.red,
                text: 'OK',
                textSize: 18,
              ),
            ),
          ],
        );
      },
    );
  }

  static errorToast({required String error}) {
    Fluttertoast.showToast(
      msg: error,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
