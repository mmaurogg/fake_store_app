import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/config/dependencies.dart';
import 'package:fake_store_app/ui/pages/home_page.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:fake_store_app/ui/widgets/auth_form.dart';
import 'package:fake_store_app/ui/widgets/custom_outline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authProvider, (previous, next) {
      if (next.isAuthenticated) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
      }
    });

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Spacer(),
              Text(
                'Fake Store te da la bienvenida',
                style: AppTheme.titleHighlightStyle,
              ),
              Spacer(),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Deseas con un usuaruio de prueba?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlineButton(
                      icon: Icons.people,
                      text: 'Iniciar con cualquier usuario',
                      onPressed: () async {
                        var response = await ref
                            .read(fakeStoreProvider)
                            .user
                            .getUser('2');
                        response.fold((error) => print(error.message), (user) {
                          if (user != null) {
                            ref.read(authProvider.notifier).login(user);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),

              Spacer(),

              AuthForm(),

              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
