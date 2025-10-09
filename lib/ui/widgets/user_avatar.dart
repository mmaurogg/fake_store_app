import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/app_theme.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final User user;
  const UserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final firstLetter = (user.username != null && user.username!.isNotEmpty)
        ? user.username![0].toUpperCase()
        : '?';
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: AppTheme().themeApp.colorScheme.primary.withAlpha(
            30,
          ),
          child: Text(
            firstLetter,
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: AppTheme().themeApp.colorScheme.primary,
            ),
          ),
        ),

        const SizedBox(height: 24),
        Text(user.username ?? 'Usuario X', style: AppTheme.titleHighlightStyle),
      ],
    );
  }
}
