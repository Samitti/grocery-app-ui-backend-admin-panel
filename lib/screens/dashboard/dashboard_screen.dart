import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/screens/order/all_order_screen.dart';
import 'package:gecoory_web_panel/screens/product/add_product_screen.dart';
import 'package:gecoory_web_panel/widgets/buttons_widget.dart';
import 'package:gecoory_web_panel/widgets/grid_product_widget.dart';
import 'package:gecoory_web_panel/widgets/header_widget.dart';
import 'package:gecoory_web_panel/widgets/order_list_widget.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  static String routeName = "/dashboard";
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    final Size size = Utils(context).getScreenSize;

    return SafeArea(
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.all(dimensions.getScreenW(16)),
        child: Column(
          children: [
            HeaderWidget(
              press: () {
                context.read<MenuControllerClass>().controlDashboarkMenu();
              },
              text: 'Dashboard',
            ),
            SizedBox(height: dimensions.getScreenH(16)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ButtonsWidget(
                  press: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AllOrdersScreen.routeName,
                    );
                  },
                  icon: Icons.store,
                  backgroundColor: Colors.blue,
                  text: 'View All',
                ),
                ButtonsWidget(
                  press: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AddProductScreen.routeName,
                    );
                  },
                  icon: Icons.add,
                  backgroundColor: Colors.blue,
                  text: 'Add Product',
                ),
              ],
            ),
            SizedBox(height: dimensions.getScreenH(16)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: dimensions.getScreenH(15),
                      ),
                      Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                        ),
                      ),
                      SizedBox(
                        height: dimensions.getScreenH(20),
                      ),
                      const OrdersListWidget(),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
