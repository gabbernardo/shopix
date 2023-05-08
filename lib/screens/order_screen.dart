import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/order_provider.dart';
import 'package:shop_app/widgets/order_item_widget.dart';

import '../widgets/app_drawer_widget.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future? _ordersFuture;

  Future _fetchOrders() async {
    return await Provider.of<OrderProvider>(context, listen: false).fetchOrder();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    print('building orders');

    /// need to comment out to prevent infinite loop of request
    /// instead use Consumer where the data is only needed to prevent infinite loop
    // final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: _ordersFuture,
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return const Center(
                  child: Text('An error occured'),
                );
              } else {
                return Consumer<OrderProvider>(
                  builder: (ctx, orderData, child) => orderData.orders.isEmpty
                      ? const Center(
                          child: Text(
                            'No Orders Yet!',
                            style: TextStyle(fontSize: 15),
                          ),
                        )
                      : ListView.builder(
                          itemCount: orderData.orders.length,
                          itemBuilder: (ctx, index) => OrderItemWidget(
                            orderItem: orderData.orders[index],
                          ),
                        ),
                );
              }
            }
          }),
    );
  }
}
