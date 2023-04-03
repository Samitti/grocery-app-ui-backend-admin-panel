import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/widgets/header_widget.dart';
import 'package:gecoory_web_panel/widgets/order_list_widget.dart';
import 'package:gecoory_web_panel/widgets/side_menu_widget.dart';
import 'package:provider/provider.dart';

class AllOrdersScreen extends StatefulWidget {
  static String routeName = "/allorders";
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    return Scaffold(
      key: context.read<MenuControllerClass>().getOrderProductscaffoldKey,
      drawer: const SideMenuWidget(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenuWidget(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                controller: ScrollController(),
                padding: EdgeInsets.all(dimensions.getScreenW(16)),
                child: Column(
                  children: [
                    SizedBox(
                      height: dimensions.getScreenH(15),
                    ),
                    HeaderWidget(
                      press: () {
                        context
                            .read<MenuControllerClass>()
                            .controlAllOrder();
                      }, text: 'All Order',
                    ),
                    SizedBox(
                      height: dimensions.getScreenH(15),
                    ),
                    Padding(
                      padding: EdgeInsets.all(dimensions.getScreenW(10)),
                      child: const OrdersListWidget(),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
