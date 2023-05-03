import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/cart_provider.dart';
import 'package:shop_app/provider/products_provider.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/badge.dart';

import '../widgets/app_drawer_widget.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { Favorites, All }

class ProductOverviewScreen extends StatefulWidget {
  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();

    /// improper call in initState because of the 'context' is not yet build
    // Provider.of<ProductsProvider>(context, listen: false).fetchProduct();
    // Future.delayed(Duration.zero).then((_) {
    //   Provider.of<ProductsProvider>(context).fetchProduct();
    // });
  }

  /// when using didChangeDependecies, put some helper on it like
  /// 'var _isInit = true;' is to check when you run this for the first time
  /// coz it run more often multiple times and
  /// not just when created like initSate
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState((){
        _isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopix'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  /// show favorite items
                  _showOnlyFavorites = true;
                } else {
                  /// show all items
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.Favorites,
                child: Text('Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.All,
                child: Text('Show All'),
              ),
            ],
          ),
          Consumer<CartProvider>(
              builder: (_, cartData, childIcon) => Badge(
                    value: cartData.itemCount.toString(),
                    child: childIcon!,
                  ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
                icon: const Icon(Icons.shopping_cart),
              ))
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading ? const Center(child: CircularProgressIndicator()) : ProductsGrid(
        showFavorite: _showOnlyFavorites,
      ),
    );
  }
}
