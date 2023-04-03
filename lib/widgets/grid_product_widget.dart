import 'package:flutter/material.dart';
import 'package:gecoory_web_panel/constants/dimension.dart';
import 'package:gecoory_web_panel/model/product_model.dart';
import 'package:gecoory_web_panel/services/products/products_firestore.dart';
import 'products_widget.dart';

class ProductGridWidget extends StatefulWidget {
  const ProductGridWidget(
      {Key? key,
      this.crossAxisCount = 4,
      this.childAspectRatio = 1,
      this.isInMain = true})
      : super(key: key);
  final int crossAxisCount;
  final double childAspectRatio;
  final bool isInMain;

  @override
  State<ProductGridWidget> createState() => _ProductGridWidgetState();
}

class _ProductGridWidgetState extends State<ProductGridWidget> {
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = ProductFireStore.getProducts();
  }

  @override
  Widget build(BuildContext context) {
    final AppDimensions dimensions = AppDimensions(context);
    return FutureBuilder(
      future: _futureProducts,
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
            child:  Center(
              child: Text('No products found'),
            ),
          );
        } else {
          final products = snapshot.data!;
          return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.isInMain && snapshot.data!.length > 4 ? 4 : snapshot.data!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.crossAxisCount,
              childAspectRatio: widget.childAspectRatio,
              crossAxisSpacing: dimensions.getScreenW(10),
              mainAxisSpacing: dimensions.getScreenW(10),
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductWidget(product: product,);
            },
          );
        }
      },
    );
  }
}
