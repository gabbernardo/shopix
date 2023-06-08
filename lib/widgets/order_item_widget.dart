import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/provider/model/order.dart';

class OrderItemWidget extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemWidget({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<OrderItemWidget> createState() => _OrderItemWidgetState();
}

class _OrderItemWidgetState extends State<OrderItemWidget> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _expanded ? min(widget.orderItem.products.length * 20 + 110, 200) : 95,
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: [
            ListTile(
              title: Text('Total: ₱ ${widget.orderItem.totalAmount.toStringAsFixed(2)}'),
              subtitle: Text(
                  'Date: ${DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.dateTime)}'),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
                height: _expanded ? min(widget.orderItem.products.length * 20 + 10, 100) : 0,
                child: ListView.builder(
                  itemCount: widget.orderItem.products.length,
                  itemBuilder: (ctx, index) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.orderItem.products[index].title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${widget.orderItem.products[index].quantity}x ₱ ${widget.orderItem.products[index].price} ',
                        style: const TextStyle(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
