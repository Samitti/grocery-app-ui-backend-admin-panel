import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/model/order_model.dart';
import 'package:gecoory_web_panel/services/order/orders_firestore.dart';
import 'package:gecoory_web_panel/widgets/order_widget.dart';

class OrdersListWidget extends StatefulWidget {
  const OrdersListWidget({Key? key, this.isInDashboard = true}) : super(key: key);
  final bool isInDashboard;

  @override
  State<OrdersListWidget> createState() => _OrdersListWidgetState();
}

class _OrdersListWidgetState extends State<OrdersListWidget> {
  late Future<List<OrderModel>> _orders;
  

  @override
  void initState() {
    super.initState();
    _orders = OrderFireStore().fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    return FutureBuilder(
      future: _orders,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: Text('No Orders Yet!'),
            ),
          );
        } else {
           final orders = snapshot.data!;
          return Container(
            padding: EdgeInsets.all(dimensions.getScreenW(16)),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius:
                  BorderRadius.all(Radius.circular(dimensions.getScreenW(10))),
            ),
            
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: widget.isInDashboard && snapshot.data!.length > 4
                      ? 4
                      : snapshot.data!.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Column(
                    children: [
                      OrdersWidget(order: order,),
                      const Divider(
                        thickness: 3,
                      ),
                    ],
                  );
                }),
          );
        }
      },
    );
  }
}
