import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../data/repositories/posts_repository.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text('Выход из аккаунта'),
          content: const Text('Вы точно хотите выйти из аккаунта?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.pop(context);
                await FirebaseAuth.instance.signOut();
              },
              child: const Text('Выйти'),
            ),
          ],
        );
      },
    );
  }

  void _showAppInfo(BuildContext context) {
    showAboutDialog(
      context: context,
      applicationName: 'Weather Social',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(Icons.cloud),
      children: const [
        Text(
          'Итоговое Flutter-приложение с погодой, профилем, постами, локальным хранением и Firebase.',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          SwitchListTile(
            value: false,
            onChanged: (value) {},
            title: const Text('Тёмная тема'),
            secondary: const Icon(Icons.dark_mode),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('О приложении'),
            onTap: () => _showAppInfo(context),
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Очистить локальные данные'),
            onTap: () async {
              await PostsRepository().clearLocalPosts();

              if (!context.mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Локальные посты очищены')),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Выйти из аккаунта'),
            onTap: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }
}
