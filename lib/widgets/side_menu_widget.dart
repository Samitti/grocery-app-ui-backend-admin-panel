import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/providers/dark_theme_provider.dart';
import 'package:gecoory_web_panel/screens/main/home_screen.dart';
import 'package:gecoory_web_panel/screens/order/all_order_screen.dart';
import 'package:gecoory_web_panel/screens/product/all_products_screen.dart';
import 'package:gecoory_web_panel/widgets/drawer_list.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

class SideMenuWidget extends StatefulWidget {
  const SideMenuWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<SideMenuWidget> createState() => _SideMenuWidgetState();
}

class _SideMenuWidgetState extends State<SideMenuWidget> {
  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final themeState = Provider.of<DarkThemeProvider>(context);
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Image.asset(
              "assets/images/groceries.png",
            ),
          ),
          DrawerListTile(
            title: "Home",
            press: () {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            },
            icon: Icons.home_filled,
          ),
          DrawerListTile(
            title: "View all product",
            press: () {
              Navigator.pushReplacementNamed(context, AllProductsScreen.routeName);
            },
            icon: Icons.store,
          ),
          DrawerListTile(
            title: "View all order",
            press: () {
              Navigator.pushReplacementNamed(context, AllOrdersScreen.routeName);
            },
            icon: IconlyBold.bag_2,
          ),
          SwitchListTile(
            title: const Text('Theme'),
            secondary: Icon(themeState.getDarkTheme
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            value: theme,
            onChanged: (value) {
              setState(
                () {
                  themeState.setDarkTheme = value;
                },
              );
            },
          )
        ],
      ),
    );
  }
}
