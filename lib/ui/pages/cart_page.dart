import 'package:fake_store_app/ui/providers/cart_provider.dart';
import 'package:fake_store_app/ui/widgets/cart_product_card.dart';
import 'package:fake_store_app/ui/widgets/custom_button.dart';
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
                    return CartProductCard(
                      cartProduct: cartProduct,
                      onPressed: () {
                        ref
                            .read(cartProvider.notifier)
                            .removeProductFromCart(cartProduct.productId);
                      },
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
                CustomButton(
                  text: "Pagar",
                  icon: Icons.credit_card,
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
