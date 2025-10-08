import 'package:fake_store_app/ui/pages/auth_page.dart';
import 'package:fake_store_app/ui/pages/home_page.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fake_store_app/main.dart' as app;

void main() {
  testWidgets("Iniciar sesion con boton 'Iniciar con cualquier usuario'", (
    tester,
  ) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(AuthPage), findsOneWidget);
    await tester.tap(find.text('Iniciar con cualquier usuario'));

    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.byType(HomePage), findsOneWidget);
  });
}
