import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/screens/dashboard/dashboard_screen.dart';
import 'package:gecoory_web_panel/screens/main/home_screen.dart';
import 'package:gecoory_web_panel/screens/order/all_order_screen.dart';
import 'package:gecoory_web_panel/screens/product/add_product_screen.dart';
import 'package:gecoory_web_panel/screens/product/all_products_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName : (context) => const HomeScreen(),
  DashboardScreen.routeName : (context) => const DashboardScreen(),
  AllOrdersScreen.routeName : (context) => const AllOrdersScreen(),
  AddProductScreen.routeName : (context) => const AddProductScreen(),
  AllProductsScreen.routeName : (context) => const AllProductsScreen(),
  // EditProductScreen.routeName : (context) => const EditProductScreen(),
};