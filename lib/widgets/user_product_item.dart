import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem({
    Key? key,
    required this.id,
    required this.title,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold =  ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                    EditProductScreen.routeName,
                    arguments: id);
              },
              icon: const Icon(Icons.edit, color: Colors.grey),
              color: Theme.of(context).colorScheme.primary
            ),
            IconButton(
              onPressed: () async {
                try{
                  await Provider.of<ProductsProvider>(context, listen: false).removeProduct(id);
                  scaffold.showSnackBar(const SnackBar(
                      content: Text('Successfully Deleted'),
                      duration: Duration(seconds: 2),
                    ),
                    );
                }catch (error){
                  scaffold.showSnackBar(const SnackBar(
                    content: Text('Deleting failed!'),
                    duration: Duration(seconds: 2),
                  ),
                  );
                }
              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
