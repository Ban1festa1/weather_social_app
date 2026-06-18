import 'package:flutter/material.dart';

import '../../../data/models/post_model.dart';
import '../../../data/repositories/posts_repository.dart';
import '../user_profile/user_profile_screen.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final postsRepository = PostsRepository();

  late Future<List<PostModel>> postsFuture;

  @override
  void initState() {
    super.initState();
    postsFuture = postsRepository.getPosts();
  }

  void _refreshPosts() {
    setState(() {
      postsFuture = postsRepository.getPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Посты пользователей'),
        actions: [
          IconButton(
            onPressed: _refreshPosts,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<List<PostModel>>(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка загрузки постов: ${snapshot.error}'),
            );
          }

          final posts = snapshot.data ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('Постов пока нет'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              _refreshPosts();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];

                return _PostCard(post: post);
              },
            ),
          );
        },
      ),
    );
  }
}

class _PostCard extends StatelessWidget {
  final PostModel post;

  const _PostCard({
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    final temperature = post.weather.temperature.toStringAsFixed(0);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text('${post.userName} — $temperature°C'),
        subtitle: Text(
          '${post.city}\n${post.comment}',
        ),
        isThreeLine: true,
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => UserProfileScreen(
                userId: post.userId,
              ),
            ),
          );
        },
      ),
    );
  }
}