import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'model/cart.dart';
import 'model/order.dart';

class OrderProvider with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrder() async {
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    try {
      final response = await http.get(url);
      final List<OrderItem> loadedOrders = [];
      final result = json.decode(response.body) as Map<String, dynamic>;
      if(result.isEmpty ){
        return;
      }
      result.forEach((orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            id: orderId,
            totalAmount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantity: item['quantity'],
                    price: item['price'],
                    imageUrl: item['imageUrl'],
                  ),
                )
                .toList(),
          ),
        );
      });
      _orders = loadedOrders;
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // print(json.decode(response.body));
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timeStamp = DateTime.now();
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartProducts
              .map((cartProd) => {
                    'id': cartProd.id,
                    'title': cartProd.title,
                    'quantity': cartProd.quantity,
                    'price': cartProd.price,
                    'imageUrl': cartProd.imageUrl,
                  })
              .toList()
        }),
      );
      _orders.insert(
        ///index starting at 0 coz for recent order at the top
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            totalAmount: total,
            products: cartProducts,
            dateTime: timeStamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
