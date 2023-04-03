import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/widgets/grid_product_widget.dart';
import 'package:gecoory_web_panel/widgets/header_widget.dart';
import 'package:gecoory_web_panel/widgets/side_menu_widget.dart';
import 'package:provider/provider.dart';

class AllProductsScreen extends StatefulWidget {
  static String routeName = "/allproducts";
  const AllProductsScreen({Key? key}) : super(key: key);

  @override
  State<AllProductsScreen> createState() => _AllProductsScreenState();
}

class _AllProductsScreenState extends State<AllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      key: context.read<MenuControllerClass>().getgridscaffoldKey,
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
                            .controlProductsMenu();
                      }, text: 'All Products',
                    ),
                    Padding(
                      padding: EdgeInsets.all(dimensions.getScreenW(10)),
                      child: Responsive(
                        mobile: ProductGridWidget(
                          crossAxisCount: size.width < 650 ? 2 : 4,
                          childAspectRatio:
                              size.width < 650 && size.width > 350 ? 1.1 : 0.8,
                          isInMain: false,
                        ),
                        desktop: ProductGridWidget(
                          childAspectRatio: size.width < 1400 ? 0.8 : 1.05,
                          isInMain: false,
                        ),
                      ),
                    ),
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
