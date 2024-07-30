import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ProductList.dart';
import 'login_screen.dart';
import 'models/product.dart';
import 'product_provider.dart';
import 'product_form.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assume 'topProductId' is the ID of the product you want at the top
    final topProductId = 'some-product-id';

    return Scaffold(
      appBar: AppBar(
        title: Text('Godown Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _logout(context);
            },
          ),
        ],
      ),
      body: ProductList(topProductId: topProductId), // Pass the top product ID
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductForm()),
          );
        },
      ),
    );
  }

  void _logout(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false,
    );
  }
}

