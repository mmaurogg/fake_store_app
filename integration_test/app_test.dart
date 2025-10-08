import 'package:fake_store_app/ui/pages/auth_page.dart';
import 'package:fake_store_app/ui/pages/cart_page.dart';
import 'package:fake_store_app/ui/pages/home_page.dart';
import 'package:fake_store_app/ui/pages/product_detail_page.dart';
import 'package:fake_store_app/ui/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'auth_test.dart' as auth;

import 'package:fake_store_app/main.dart' as app;

void main() {
  //inicializacion del test de integracion
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  //auth.main();

  setUpAll(() {});

  testWidgets("end-to-end agregar producto a carrito", (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Autenticarse
    expect(find.byType(AuthPage), findsOneWidget);
    await tester.tap(find.text('Iniciar con cualquier usuario'));

    await tester.pumpAndSettle(const Duration(seconds: 2));

    expect(find.byType(HomePage), findsOneWidget);

    // ---- Entrar a la vista detalles de un producto
    await tester.tap(find.byKey(Key('home_nav_item')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.byType(ProductsPage), findsOneWidget);

    final idProduct = 2;

    await tester.dragUntilVisible(
      find.byKey(Key('short_card_$idProduct')),
      find.byKey(const Key('scroll_products')),
      const Offset(0, -200),
    );

    await tester.tap(find.byKey(Key('short_card_$idProduct')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(ProductDetailPage), findsOneWidget);

    // Agregar producto a carrito
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);

    // confirmar que quedo agregado al carrito
    await tester.tap(find.byKey(Key('cart_nav_item')));
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(CartPage), findsOneWidget);
    expect(find.byKey(Key('cart_product_$idProduct')), findsOneWidget);
  });
}
