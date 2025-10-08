import 'package:fake_store/fake_store.dart';
import 'package:flutter/material.dart';

class CartProductCard extends StatelessWidget {
  final CartProduct cartProduct;
  final VoidCallback onPressed;

  const CartProductCard({
    super.key,
    required this.cartProduct,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: ListTile(
        key: Key('cart_product_${cartProduct.productId}'),
        title: Text("Product ID: ${cartProduct.productId}"),
        trailing: Text("Quantity: ${cartProduct.quantity}"),
        leading: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onPressed,
        ),
      ),
    );
    ;
  }
}
