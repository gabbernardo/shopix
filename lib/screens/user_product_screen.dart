import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';

import '../widgets/app_drawer_widget.dart';
import '../widgets/user_product_item.dart';
import 'edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-product';

  const UserProductScreen({Key? key}) : super(key: key);

  Future<void> _fetchData(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    // final listOfProducts = Provider.of<ProductsProvider>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: [
            IconButton(
                onPressed: () {
                  /// navigate to new screen for adding new product
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _fetchData(context),
          builder: (ctx, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : RefreshIndicator(
                      onRefresh: () => _fetchData(context),
                      child: Consumer<ProductsProvider>(
                        builder: (ctx, listOfProducts, _) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: listOfProducts.items.length,
                            itemBuilder: (_, index) => Column(
                              children: [
                                UserProductItem(
                                  id: listOfProducts.items[index].id,
                                  title: listOfProducts.items[index].title,
                                  imageUrl: listOfProducts.items[index].imageUrl,
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
        ));
  }
}
