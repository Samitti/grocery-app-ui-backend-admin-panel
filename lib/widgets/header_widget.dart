import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({
    Key? key,
    required this.press, required this.text, this.showSearchField = true,
  }) : super(key: key);

  final void Function()? press;
  final String text;
  final bool showSearchField;
  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    return Row(
      children: [
        if (!Responsive.isDesktop(context))
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: press
          ),
        if (Responsive.isDesktop(context))
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
        if (Responsive.isDesktop(context))
          Spacer(flex: Responsive.isDesktop(context) ? 2 : 1),
        !showSearchField ? Container():
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              fillColor: Theme.of(context).cardColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(dimensions.getScreenW(10))),
              ),
              suffixIcon: InkWell(
                onTap: () {},
                child: Container(
                  padding: EdgeInsets.all(dimensions.getScreenW(10)),
                  margin: EdgeInsets.symmetric(
                      horizontal: dimensions.getScreenW(8)),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.all(Radius.circular(dimensions.getScreenW(10))),
                  ),
                  child: Icon(
                    Icons.search,
                    size: dimensions.getScreenW(25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
