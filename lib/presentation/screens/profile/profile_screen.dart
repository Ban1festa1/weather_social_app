import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/repositories/posts_repository.dart';
import '../../../data/repositories/profile_repository.dart';
import '../../../data/repositories/user_repository.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileRepository = ProfileRepository();
  final userRepository = UserRepository();
  final postsRepository = PostsRepository();

  String? avatarPath;
  int postsCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final loadedAvatarPath = await profileRepository.getAvatarPath();
    final posts = await postsRepository.getPostsByUserId('current_user');

    if (!mounted) return;

    setState(() {
      avatarPath = loadedAvatarPath;
      postsCount = posts.length;
      isLoading = false;
    });
  }

  Future<void> _pickAvatar() async {
    final newAvatarPath = await profileRepository.pickAndSaveAvatar();

    if (!mounted) return;

    if (newAvatarPath != null) {
      setState(() {
        avatarPath = newAvatarPath;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Фото профиля сохранено'),
        ),
      );
    }
  }

  Future<void> _deleteAvatar() async {
    await profileRepository.deleteAvatar();

    if (!mounted) return;

    setState(() {
      avatarPath = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Фото профиля удалено'),
      ),
    );
  }

  void _showPhotoModal() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Выбрать фото из галереи'),
                onTap: () async {
                  Navigator.pop(context);
                  await _pickAvatar();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Удалить фото'),
                onTap: () async {
                  Navigator.pop(context);
                  await _deleteAvatar();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = userRepository.getCurrentUser();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мой профиль'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _showPhotoModal,
                    child: CircleAvatar(
                      radius: 56,
                      backgroundImage: avatarPath != null
                          ? FileImage(File(avatarPath!))
                          : null,
                      child: avatarPath == null
                          ? const Icon(
                              Icons.person,
                              size: 56,
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  currentUser.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  currentUser.email,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  currentUser.city,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.article),
                    title: const Text('Мои посты'),
                    subtitle: Text('Количество постов: $postsCount'),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Фото профиля'),
                    subtitle: Text(
                      avatarPath == null
                          ? 'Фото ещё не выбрано'
                          : 'Фото сохранено локально',
                    ),
                    onTap: _showPhotoModal,
                  ),
                ),
              ],
            ),
    );
  }
}