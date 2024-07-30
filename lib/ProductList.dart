import 'package:flutter/material.dart';
import 'package:godown_management_flutter/product_form.dart';
import 'package:godown_management_flutter/product_provider.dart';
import 'package:provider/provider.dart';

import 'models/product.dart';

class ProductList extends StatelessWidget {
  final String topProductId;

  ProductList({required this.topProductId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        List<Product> products = productProvider.getSortedProducts(topProductId);
        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ListTile(
              title: Text(
                product.name,
                style: TextStyle(
                  color: product.quantity < 5 ? Colors.red : Colors.black, // Red color for low stock
                ),
              ),
              subtitle: Text('Quantity: ${product.quantity}'),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ProductForm(product: product),
                    ),
                  );
                },
              ),
              onLongPress: () {
                _showDeleteDialog(context, productProvider, product);
              },
            );
          },
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, ProductProvider productProvider, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                productProvider.removeProduct(product.id);
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
