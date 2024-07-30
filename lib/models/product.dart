import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String id;
  String name;
  int quantity;
  DateTime timestamp; // Ensure this field is included

  Product({
    required this.id,
    required this.name,
    required this.quantity,
    required this.timestamp,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      timestamp: (json['timestamp'] as Timestamp).toDate(), // Ensure timestamp is correctly parsed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'timestamp': Timestamp.fromDate(timestamp), // Ensure timestamp is correctly serialized
    };
  }
}
