import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store App',
      theme: ThemeData(colorScheme: AppTheme().themeApp.colorScheme),
      home: const HomePage(),
    );
  }
}
