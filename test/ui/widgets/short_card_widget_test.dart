import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/ui/widgets/short_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets("widget contains product info", (tester) async {
    final product = Product(
      title: "test",
      category: "category",
      image: "image",
      price: 10.0,
      description: "description",
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ShortCardWidget(product: product, onTap: () {}),
        ),
      ),
    );

    final titleFinder = find.text(product.title!);
    final categoryFinder = find.text(product.category!);
    final priceFinder = find.text(product.price.toString());

    expect(titleFinder, findsOneWidget);
    expect(categoryFinder, findsOneWidget);
    expect(priceFinder, findsOneWidget);
  });
}
