import 'package:fake_store_app/ui/pages/auth_page.dart';
import 'package:fake_store_app/ui/pages/cart_page.dart';
import 'package:fake_store_app/ui/pages/home_page.dart';
import 'package:fake_store_app/ui/pages/product_detail_page.dart';
import 'package:fake_store_app/ui/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'auth_test.dart' as auth;
import 'cart_test.dart' as cart;

import 'package:fake_store_app/main.dart' as app;

void main() {
  //inicializacion del test de integracion
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {});
  auth.main();
  cart.main();
}
