import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/provider/model/http_exception.dart';
import 'dart:convert';

import 'model/product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this.userId, this._items);

  // var _showFavoritesOnly = false;

  List<Product> get items {
    // if(_showFavoritesOnly){
    //   return _items.where((item) => item.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItems) => prodItems.isFavorite).toList();
  }

  Product findById(String id) {
    return items.firstWhere((product) => product.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  //
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchProduct() async {
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    final favoriteUrl = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final result = jsonDecode(response.body) as Map<String, dynamic>?;
      if (result == null) {
        return;
      }
      final favoriteResponse = await http.get(favoriteUrl);
      final favoriteData = json.decode(favoriteResponse.body);

      /// temporary list of Data
      final List<Product> loadedProducts = [];
      result.forEach((prodId, prodData) {
        loadedProducts.add(
          Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
      // print(jsonDecode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    /** using endpoint as '/products.json'
     * is because Firebase requires this when
     * parsing your incoming request
     * **/
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
        }),
      );
      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );
      _items.add(newProduct);

      ///insert at the start of the list
      // _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product updatedProduct) async {
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    if (productIndex >= 0) {
      try {
        final url = Uri.parse(
            'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
        await http.patch(
          url,
          body: json.encode({
            'title': updatedProduct.title,
            'description': updatedProduct.description,
            'price': updatedProduct.price,
            'imageUrl': updatedProduct.imageUrl
          }),
        );
        _items[productIndex] = updatedProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> removeProduct(String id) async {
    final url = Uri.parse(
        'https://shopix-8d8fd-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$authToken');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];
    // immediately delete the product then store it in memory for a while
    existingProduct = null;
    _items.removeAt(existingProductIndex);
    // then if the response is error, it will fetch the data that has been store in memory and show in UI
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct!);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    notifyListeners();
  }
}
