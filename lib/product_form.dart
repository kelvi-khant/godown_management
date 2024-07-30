import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'product_provider.dart';

class ProductForm extends StatefulWidget {
  final Product? product;

  ProductForm({this.product});

  @override
  _ProductFormState createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late int _initialQuantity;
  late int _usedQuantity;
  late int _addQuantity;

  @override
  void initState() {
    super.initState();
    _name = widget.product?.name ?? '';
    _initialQuantity = widget.product?.quantity ?? 0;
    _usedQuantity = 0;
    _addQuantity = 0; // Initialize the new field
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              TextFormField(
                initialValue: _initialQuantity.toString(),
                decoration: InputDecoration(labelText: 'ટોટલ'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter initial quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _initialQuantity = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _usedQuantity.toString(),
                decoration: InputDecoration(labelText: 'વપરાયેલ'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter used quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _usedQuantity = int.parse(value!);
                },
              ),
              TextFormField(
                initialValue: _addQuantity.toString(),
                decoration: InputDecoration(labelText: 'નવી આવેલી '),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter add quantity';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addQuantity = int.parse(value!);
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    int finalQuantity = _initialQuantity + _addQuantity - _usedQuantity;
                    if (finalQuantity < 5) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Alert: Final quantity is below the threshold!'),
                        ),
                      );
                    }
                    final product = Product(
                      id: widget.product?.id ?? DateTime.now().toString(),
                      name: _name,
                      quantity: finalQuantity,
                      timestamp: DateTime.now(), // Provide the current timestamp
                    );

                    if (widget.product == null) {
                      Provider.of<ProductProvider>(context, listen: false).addProduct(product);
                    } else {
                      Provider.of<ProductProvider>(context, listen: false).updateProduct(product);
                    }
                    Navigator.of(context).pop();
                  }
                },
                child: Text(widget.product == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
