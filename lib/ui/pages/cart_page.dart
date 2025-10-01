import 'package:fake_store_app/ui/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartState = ref.watch(cartProvider);
    final cart = cartState.cart;
    final productsInCart = cart?.products ?? [];
    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (cartState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (productsInCart.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text('Tu carrito esta vacio'),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: productsInCart.length,
                itemBuilder: (context, index) {
                  final cartProduct = productsInCart[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 4.0,
                    ),
                    child: ListTile(
                      title: Text("Product ID: ${cartProduct.productId}"),
                      trailing: Text("Quantity: ${cartProduct.quantity}"),
                      // TODO: boton para borrar
                    ),
                  );
                },
              ),
            if (cartState.error != null)
              Center(
                child: Text(
                  'Error: ${cartState.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
