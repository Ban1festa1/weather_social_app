import 'package:flutter/material.dart';

import '../../../data/models/post_model.dart';
import '../../../data/models/weather_model.dart';
import '../../../data/repositories/posts_repository.dart';

class CreatePostScreen extends StatefulWidget {
  final WeatherModel weather;

  const CreatePostScreen({
    super.key,
    required this.weather,
  });

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final commentController = TextEditingController();
  final postsRepository = PostsRepository();

  bool isSaving = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> _publishPost() async {
    final comment = commentController.text.trim();

    if (comment.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Введите комментарий к погоде'),
        ),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final post = PostModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'current_user',
      userName: 'Мой пользователь',
      city: widget.weather.city,
      comment: comment,
      weather: widget.weather,
      createdAt: DateTime.now(),
    );

    await postsRepository.addPost(post);

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final temperature = widget.weather.temperature.toStringAsFixed(0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Создать пост'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.cloud),
                title: const Text('Текущая погода'),
                subtitle: Text('${widget.weather.city}, $temperature°C'),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Комментарий',
                hintText: 'Например: отличная погода для прогулки',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: isSaving ? null : _publishPost,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(isSaving ? 'Сохранение...' : 'Опубликовать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}