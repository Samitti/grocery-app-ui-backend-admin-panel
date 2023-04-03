import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/responsive.dart';
import 'package:gecoory_web_panel/controllers/menu_controller.dart';
import 'package:gecoory_web_panel/screens/dashboard/dashboard_screen.dart';
import 'package:gecoory_web_panel/widgets/side_menu_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/mainscreen";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: context.read<MenuControllerClass>().getScaffoldKey,
      drawer: const SideMenuWidget(),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenuWidget(),
              ),
            const Expanded(
              flex: 5,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }
}