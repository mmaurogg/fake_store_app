import 'package:fake_store_app/config/app_theme.dart';
import 'package:flutter/material.dart';

class CustomOutlineButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  const CustomOutlineButton({
    super.key,
    required this.text,
    required this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppTheme().themeApp.colorScheme.primary,
        side: BorderSide(color: AppTheme().themeApp.colorScheme.primary),
      ),
    );
  }
}
