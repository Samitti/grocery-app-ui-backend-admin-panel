import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gecoory_web_panel/constants/common_function.dart';
import 'package:gecoory_web_panel/model/product_model.dart';


// constants

const String constProduct = "products";

class ProductFireStore {
  static Future<void> addProduct(ProductModel product) async {
    try {
      await FirebaseFirestore.instance
          .collection(constProduct)
          .doc(product.id)
          .set(product.toMap());
    } catch (error) {
      CommonFunctions.errorToast(error: 'Error Uploading Product');
    }
  }

  static Future<List<ProductModel>> getProducts() async {
    try {
      final querySnapshot =
          await FirebaseFirestore.instance.collection(constProduct).get();
      final products = querySnapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data()))
          .toList();
      return products;
    } catch (error) {
      CommonFunctions.errorToast(error: 'Error Loading Product');
      rethrow;
    }
  }

  static Future<ProductModel?> getProductById(String productId) async {
    try {
      final documentSnapshot = await FirebaseFirestore.instance
          .collection(constProduct)
          .doc(productId)
          .get();
      if (documentSnapshot.exists) {
        final product = ProductModel.fromMap(documentSnapshot.data()!);
        return product;
      } else {
        return null;
      }
    } catch (error) {
      CommonFunctions.errorToast(error: 'Error Loading Product');
      rethrow;
    }
  }

  static Future<void> editProduct(ProductModel product) async {
    final collection = FirebaseFirestore.instance.collection(constProduct);
    final document = collection.doc(product.id);
    await document.update({
      'title': product.title,
      'price': product.price,
      'salePrice': product.salePrice,
      'imageUrl': product.imageUrl,
      'productCategory': product.productCategory,
      'isOnSale': product.isOnSale,
      'isPiece': product.isPiece,
    });
  }

  static Future<void> deleteProduct(String productId) async {
    final collection = FirebaseFirestore.instance.collection(constProduct);
    final document = collection.doc(productId);
    await document.delete();
  }
}
