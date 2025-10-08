import 'package:fake_store_app/ui/providers/auth_provider.dart';
import 'package:fake_store_app/ui/widgets/profile_info_tile.dart';
import 'package:fake_store_app/ui/widgets/user_avatar.dart';
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
              UserAvatar(user: user),
              const SizedBox(height: 32),
              ProfileInfoTile(
                icon: Icons.person_outline,
                title: 'Username',
                subtitle: user.username ?? 'No disponible',
              ),
              const Divider(),
              ProfileInfoTile(
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
}
