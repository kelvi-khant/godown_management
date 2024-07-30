import 'package:cloud_firestore/cloud_firestore.dart';
import 'models/product.dart';

class DatabaseHelper {
  final CollectionReference productCollection = FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProducts() {
    return productCollection
        .orderBy('timestamp', descending: true) // Ensure all products are fetched
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> insertProduct(Product product) async {
    await productCollection.doc(product.id).set(product.toJson());
  }

  Future<void> updateProduct(Product product) async {
    await productCollection.doc(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await productCollection.doc(id).delete();
  }
}
