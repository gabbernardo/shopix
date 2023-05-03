import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/cart_provider.dart';

class CartItemWidget extends StatelessWidget {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;
  final String? imageUrl;
  final String? productId;

  const CartItemWidget(
      {Key? key,
      required this.id,
      required this.title,
      required this.quantity,
      required this.price,
      required this.imageUrl,
      required this.productId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cartItem = Provider.of<CartProvider>(context, listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
       return showDialog(
          context: context,
          builder: (ctx) =>  AlertDialog(
            title: const Text('Are you sure? '),
            content: const Text('Do you want to remove the item from the cart?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(false);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        cartItem.removeItem(productId!);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15.0,
          vertical: 4.0,
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.network(
                  imageUrl!,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error);
                  },
                  frameBuilder:
                      (context, child, frame, wasSynchronouslyLoaded) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1.0,
                        ),
                      ),
                      child: child,
                    );
                  },
                ),
                title: Text(title!),
                subtitle:
                    Text('Total: ₱ ${(price! * quantity!).toStringAsFixed(2)}'),
                trailing: Text('Quantity: $quantity'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
