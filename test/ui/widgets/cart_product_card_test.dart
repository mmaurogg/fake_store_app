import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/ui/widgets/cart_product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("widget contains product info", (tester) async {
    final cartProduct = CartProduct(id: 0, productId: 0, quantity: 0);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CartProductCard(cartProduct: cartProduct, onPressed: () {}),
        ),
      ),
    );

    final productId = find.text("Product ID: ${cartProduct.productId}");
    final quantity = find.text("Quantity: ${cartProduct.quantity}");

    expect(productId, findsOneWidget);
    expect(quantity, findsOneWidget);
  });
}
