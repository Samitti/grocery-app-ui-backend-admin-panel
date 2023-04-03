import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/model/order_model.dart';

import 'text_widget.dart';

class OrdersWidget extends StatelessWidget {
  const OrdersWidget({Key? key, required this.order}) : super(key: key);

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;
    final AppDimensions dimensions = AppDimensions(context);
    late String orderDateStr;
    var postDate = order.orderDate.toDate();
    orderDateStr = '${postDate.day}/${postDate.month}/${postDate.year}';

    return Padding(
      padding: EdgeInsets.all(dimensions.getScreenW(8)),
      child: Material(
        borderRadius: BorderRadius.circular(dimensions.getScreenW(8)),
        color: Theme.of(context).cardColor.withOpacity(0.4),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  order.productImageUrl,
                  fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: dimensions.getScreenH(12),
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: '${order.productQuantity}X For \$${order.totalPrice}',
                      color: color,
                      textSize: dimensions.getScreenW(16),
                      isTitle: true,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'By: ',
                            color: Colors.blue,
                            textSize: dimensions.getScreenW(16),
                            isTitle: true,
                          ),
                          TextWidget(
                            text: order.userName,
                            color: color,
                            textSize: dimensions.getScreenW(14),
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          TextWidget(
                            text: 'Address: ',
                            color: Colors.blue,
                            textSize: dimensions.getScreenW(16),
                            isTitle: true,
                          ),
                          TextWidget(
                            text: order.userAddress,
                            color: color,
                            textSize: dimensions.getScreenW(14),
                            isTitle: true,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      orderDateStr,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
