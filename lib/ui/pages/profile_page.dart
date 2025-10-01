import 'package:fake_store/fake_store.dart';
import 'package:fake_store_app/config/app_theme.dart';
import 'package:fake_store_app/ui/pages/auth_page.dart';
import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    if (user == null) {
      return const Center(child: Text("No hay información de usuario."));
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildAvatar(user),
              const SizedBox(height: 24),
              Text(
                user.username ?? 'Usuario',
                style: AppTheme().titleHighlightStyle,
              ),
              const SizedBox(height: 32),
              _ProfileInfoTile(
                icon: Icons.person_outline,
                title: 'Username',
                subtitle: user.username ?? 'No disponible',
              ),
              const Divider(),
              _ProfileInfoTile(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: user.email ?? 'No disponible',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(User user) {
    final firstLetter = (user.username != null && user.username!.isNotEmpty)
        ? user.username![0].toUpperCase()
        : '?';
    return CircleAvatar(
      radius: 60,
      backgroundColor: AppTheme().themeApp.colorScheme.primary.withOpacity(0.2),
      child: Text(
        firstLetter,
        style: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.bold,
          color: AppTheme().themeApp.colorScheme.primary,
        ),
      ),
    );
  }
}

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppTheme().themeApp.colorScheme.primary),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
    );
  }
}
