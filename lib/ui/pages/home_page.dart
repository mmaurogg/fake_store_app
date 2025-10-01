import 'dart:ffi';

import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/ui/pages/auth_page.dart';
import 'package:fake_store_app/ui/pages/cart_page.dart';
import 'package:fake_store_app/ui/pages/products_page.dart';
import 'package:fake_store_app/ui/pages/profile_page.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:fake_store_app/ui/providers/cart_provider.dart';
import 'package:fake_store_app/ui/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _pageController = PageController(initialPage: 1);

  int currentIndex = 1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_initPages);
  }

  _initPages([_]) {
    ref.read(productProvider.notifier).getAllProducts();

    int userId = ref.watch(authProvider).user?.id ?? 0;
    ref.read(cartProvider.notifier).getUserCart(userId);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Fake Store App'),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                ref.read(authProvider.notifier).logout();

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const AuthPage()),
                  (Route<dynamic> route) => false,
                );
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [ProfilePage(), ProductsPage(), CartPage()],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {
              currentIndex = value;
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
              //_pageController.jumpToPage(value);
              currentIndex = value;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Profile',
              activeIcon: Icon(
                Icons.person,
                color: AppTheme().themeApp.colorScheme.primary,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              label: 'home',
              activeIcon: Icon(
                Icons.shopping_bag,
                color: AppTheme().themeApp.colorScheme.primary,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              label: 'Cart',
              activeIcon: Icon(
                Icons.shopping_cart,
                color: AppTheme().themeApp.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
