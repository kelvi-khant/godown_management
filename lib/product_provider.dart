import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'database_helper.dart';
import 'models/product.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ProductProvider() {
    _initializeNotifications();
    _listenToProducts();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void _listenToProducts() {
    _databaseHelper.getProducts().listen((products) {
      print('Products updated: ${products.map((p) => p.name).toList()}');
      _products = products;
      notifyListeners();
      _checkAllLowStock(products);
    });
  }

  Future<void> _sendLowStockNotification(Product product) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'low_stock_channel',
      'Low Stock Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.show(
      0,
      'Low Stock Alert',
      'Product ${product.name} is below the stock threshold',
      platformChannelSpecifics,
      payload: 'item id ${product.id}',
    );
  }

  List<Product> get products => _products;

  Future<void> addProduct(Product product) async {
    try {
      await _databaseHelper.insertProduct(product);
      print('Product added: ${product.name}');
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateProduct(Product product) async {
    try {
      await _databaseHelper.updateProduct(product);
      print('Product updated: ${product.name}');
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> removeProduct(String id) async {
    try {
      await _databaseHelper.deleteProduct(id);
      print('Product removed: $id');
    } catch (e) {
      print('Error removing product: $e');
    }
  }

  void _checkAllLowStock(List<Product> products) {
    for (var product in products) {
      _checkLowStock(product);
    }
  }

  void _checkLowStock(Product product) {
    if (product.quantity < 15) {
      _sendLowStockNotification(product);
    }
  }

  // Add method to get products sorted with a specific product at the top
  List<Product> getSortedProducts(String topProductId) {
    List<Product> sortedProducts = List.from(_products);
    sortedProducts.sort((a, b) {
      if (a.id == topProductId) return -1; // Move top product to the top
      if (b.id == topProductId) return 1;
      return 0;
    });
    return sortedProducts;
  }
}

