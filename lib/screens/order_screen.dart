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
  var _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_isInit){
      Provider.of<OrderProvider>(context, listen: false).fetchOrder();
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<OrderProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Screen'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) => OrderItemWidget(
            orderItem: orderData.orders[index],
        ),
      ),
    );
  }
}
