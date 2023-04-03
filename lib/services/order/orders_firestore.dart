import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gecoory_web_panel/model/order_model.dart';

//constant

const String constOrder = "orders";

class OrderFireStore {
  Future<List<OrderModel>> fetchOrders() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection(constOrder).get();
    final List<OrderModel> orders = [];
    for (final doc in querySnapshot.docs) {
      final order = OrderModel.fromFirestore(doc);
      orders.add(order);
    }
    return orders;
  }
}
