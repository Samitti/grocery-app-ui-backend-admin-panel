import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String title;
  final double price;
  final double salePrice;
  final String imageUrl;
  final String productCategory;
  final bool isOnSale;
  final bool isPiece;
  final Timestamp createdAt = Timestamp.now();

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.salePrice,
    required this.imageUrl,
    required this.productCategory,
    required this.isOnSale,
    required this.isPiece,
  });

  // Converts product data to a map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      constProductId: id,
      constProductTitle: title,
      constProductPrice: price,
      constProductPriceSale: salePrice,
      constProductImage: imageUrl,
      constProductCategory: productCategory,
      constProductIsOnSale: isOnSale,
      constProductIsPiece: isPiece,
      constProductCreatedAt: createdAt,
    };
  }

  // Converts Firestore data to a Product object
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map[constProductId],
      title: map[constProductTitle],
      price: map[constProductPrice],
      salePrice: map[constProductPriceSale],
      imageUrl: map[constProductImage],
      productCategory: map[constProductCategory],
      isOnSale: map[constProductIsOnSale],
      isPiece: map[constProductIsPiece],
    );
  }
}

// products constant

const String constProductId = "id";
const String constProductTitle = "title";
const String constProductImage = "imageUrl";
const String constProductCategory = "productCategory";
const String constProductPrice = "price";
const String constProductPriceSale = "salePrice";
const String constProductIsOnSale = "isOnSale";
const String constProductIsPiece = "isPiece";
const String constProductCreatedAt = "createdAt";
