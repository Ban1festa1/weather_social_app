import 'package:flutter/material.dart';

import '../../../data/repositories/posts_repository.dart';
import '../../../data/repositories/user_repository.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepository();
    final postsRepository = PostsRepository();

    final user = userRepository.getUserById(userId);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Профиль пользователя'),
        ),
        body: const Center(
          child: Text('Пользователь не найден'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Профиль: ${user.name}'),
      ),
      body: FutureBuilder(
        future: postsRepository.getPostsByUserId(userId),
        builder: (context, snapshot) {
          final posts = snapshot.data ?? [];

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const CircleAvatar(
                radius: 56,
                child: Icon(
                  Icons.person,
                  size: 56,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                user.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                user.email,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                user.city,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                'Посты пользователя',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              if (snapshot.connectionState == ConnectionState.waiting)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else if (posts.isEmpty)
                const Card(
                  child: ListTile(
                    leading: Icon(Icons.article),
                    title: Text('Постов пока нет'),
                  ),
                )
              else
                ...posts.map((post) {
                  final temperature = post.weather.temperature.toStringAsFixed(0);

                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.cloud),
                      title: Text('${post.city}, $temperature°C'),
                      subtitle: Text(post.comment),
                    ),
                  );
                }),
            ],
          );
        },
      ),
    );
  }
}