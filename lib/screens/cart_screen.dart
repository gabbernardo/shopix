import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/provider/order_provider.dart';

import '../widgets/cart_item_widget.dart';
import '../provider/cart_provider.dart';
import 'order_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '₱ ${cartItem.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleSmall
                              ?.color),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  OrderButton(cartItem: cartItem)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cartItem.items.length,
                itemBuilder: (ctx, index) => CartItemWidget(
                    id: cartItem.items.values.toList()[index].id,
                    productId: cartItem.items.keys.toList()[index],
                    title: cartItem.items.values.toList()[index].title,
                    quantity: cartItem.items.values.toList()[index].quantity,
                    price: cartItem.items.values.toList()[index].price,
                    imageUrl: cartItem.items.values.toList()[index].imageUrl)),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartProvider cartItem;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartItem.totalAmount <= 0 || _isLoading) ? null : () async {
        setState(() {
          _isLoading = true;
        });
        await Provider.of<OrderProvider>(context, listen: false).addOrder(
          widget.cartItem.items.values.toList(),
          widget.cartItem.totalAmount,
        );
        setState(() {
          _isLoading = false;
        });
        widget.cartItem.clearCart();
        Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
      },
      child: _isLoading ? const CircularProgressIndicator() : const Text('Place Order'),
    );
  }
}
