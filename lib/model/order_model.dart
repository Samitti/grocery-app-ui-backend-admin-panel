import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel{
  final String orderId;
  final String userId;
  final String userName;
  final String userAddress;
  final String productId;
  final String productImageUrl;
  final String totalPrice;
  final String productQuantity;
  final Timestamp orderDate;

  OrderModel({
    required this.orderId,
    required this.userId,
    required this.userName,
    required this.userAddress,
    required this.productId,
    required this.productImageUrl,
    required this.totalPrice,
    required this.productQuantity,
    required this.orderDate,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      orderId: doc.id,
      userId: data[constOrderUserId] ?? '',
      userName: data[constOrderUserName] ?? '',
      userAddress: data[constOrderUserAddress] ?? '',
      productId: data[constOrderProductId] ?? '',
      productImageUrl: data[constOrderProductImage] ?? '',
      totalPrice: data[constOrderProductPrice] ?? '',
      productQuantity: data[constOrderQuantity] ?? '',
      orderDate: data[constOrderDate] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      constOrderId: orderId,
      constOrderUserId: userId,
      constOrderUserName: userName,
      constOrderUserAddress: userAddress,
      constOrderProductId: productId,
      constOrderProductImage: productImageUrl,
      constOrderProductPrice: totalPrice,
      constOrderQuantity: productQuantity,
      constOrderDate: orderDate
    };
  }
}


// order constant
const String constOrderId = "orderId";
const String constOrderUserId = "userid";
const String constOrderUserName = "username";
const String constOrderUserAddress = "user-shipping-address";
const String constOrderProductId = "productid";
const String constOrderProductImage = "productimageUrl";
const String constOrderQuantity = "productquantity";
const String constOrderProductPrice = "productprice";
const String constOrderDate = "createdAt";
