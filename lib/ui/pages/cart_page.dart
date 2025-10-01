import 'package:fake_store_app/config/app_theme.dart';
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

    if (cartState.isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (productsInCart.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Text('Tu carrito esta vacio'),
        ),
      );
    }

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
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
                        leading: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .removeProductFromCart(cartProduct.productId);
                          },
                        ),
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
        ),

        Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: cartState.isLoading
                      ? null
                      : () async {
                          if (cart != null) {
                            await ref
                                .read(cartProvider.notifier)
                                .postUserCart(cart)
                                .then(
                                  (_) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                        SnackBar(
                                          content: Text('Pago realizado'),
                                        ),
                                      ),
                                )
                                .onError(
                                  (error, stackTrace) =>
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text('Error al pagar'),
                                        ),
                                      ),
                                );
                            ;
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme().themeApp.colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.credit_card),
                  label: cartState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Pagar",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),

            SizedBox(height: 10),
          ],
        ),
      ],
    );
  }

  _postCart() {}
}
