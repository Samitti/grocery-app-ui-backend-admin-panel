import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/constants/utils.dart';
import 'package:gecoory_web_panel/model/product_model.dart';
import 'package:gecoory_web_panel/screens/product/edit_product_screen.dart';
import 'text_widget.dart';

class ProductWidget extends StatelessWidget {
  final ProductModel product;
  const ProductWidget({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {


    Size size = Utils(context).getScreenSize;
    final color = Utils(context).color;
    final AppDimensions dimensions = AppDimensions(context);
    return InkWell(
      borderRadius: BorderRadius.circular(dimensions.getScreenW(12)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditProductScreen(productId: product.id),
          ),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: dimensions.getScreenH(20),
          ),
          Align(
            alignment: Alignment.center,
            child: Image(
              fit: BoxFit.fill,
              height: size.width * 0.15,
              width: size.width * 0.15,
              image: NetworkImage(
                product.imageUrl,
              ),
            ),
          ),
          SizedBox(
            height: dimensions.getScreenH(10),
          ),
          Center(
            child: TextWidget(
              text: product.title,
              color: color,
              textSize: dimensions.getScreenW(25),
              isTitle: true,
            ),
          ),
          SizedBox(
            height: dimensions.getScreenH(1),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: dimensions.getScreenH(20)),
            child: Row(
              children: [
                TextWidget(
                  text: product.isOnSale
                      ? product.salePrice.toString()
                      : product.price.toString(),
                  color: color,
                  textSize: dimensions.getScreenW(18),
                ),
                SizedBox(
                  width: dimensions.getScreenW(7),
                ),
                Visibility(
                  visible: product.isOnSale,
                  child: Text(
                    product.price.toString(),
                    style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                TextWidget(
                  text: product.isPiece ? '1 Piece' : '1KG',
                  color: color,
                  textSize: dimensions.getScreenW(18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
