import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite ;

  const ProductsGrid({super.key, required this.showFavorite});


  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProvider>(context);
    final listOfProducts = showFavorite ? productsData.favoriteItems : productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: listOfProducts.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),

      /// using ChangeNotifierProvider.value
      /// when the value doesn't depend on the context this instead of builder
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: listOfProducts[index],
        //create: (ctx) => listOfProducts[index],
        child: ProductItem(
            // id: listOfProducts[index].id,
            // title: listOfProducts[index].title,
            // imageUrl: listOfProducts[index].imageUrl
            ),
      ),
    );
  }
}
