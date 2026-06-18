import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/post_model.dart';
import '../models/weather_model.dart';

class PostsRepository {
  static const String _localPostsKey = 'local_posts';

  List<PostModel> getFakePosts() {
    return [
      PostModel(
        id: 'post_1',
        userId: 'user_1',
        userName: 'Алина',
        city: 'Москва',
        comment: 'Хорошая погода для прогулки.',
        weather: WeatherModel(
          city: 'Москва',
          temperature: 18,
          windSpeed: 3.4,
          weatherCode: 1,
          dateTime: DateTime.now(),
        ),
        createdAt: DateTime.now().subtract(const Duration(minutes: 25)),
      ),
      PostModel(
        id: 'post_2',
        userId: 'user_2',
        userName: 'Игорь',
        city: 'Санкт-Петербург',
        comment: 'Пасмурно, но терпимо.',
        weather: WeatherModel(
          city: 'Санкт-Петербург',
          temperature: 12,
          windSpeed: 5.1,
          weatherCode: 3,
          dateTime: DateTime.now(),
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      PostModel(
        id: 'post_3',
        userId: 'user_3',
        userName: 'Марина',
        city: 'Казань',
        comment: 'Тепло и приятно.',
        weather: WeatherModel(
          city: 'Казань',
          temperature: 21,
          windSpeed: 2.8,
          weatherCode: 0,
          dateTime: DateTime.now(),
        ),
        createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];
  }

  Future<List<PostModel>> getLocalPosts() async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList(_localPostsKey) ?? [];

    return postsJson.map((postString) {
      final Map<String, dynamic> json = jsonDecode(postString);
      return PostModel.fromJson(json);
    }).toList();
  }

  Future<List<PostModel>> getPosts() async {
    final localPosts = await getLocalPosts();
    final fakePosts = getFakePosts();

    return [
      ...localPosts,
      ...fakePosts,
    ];
  }

  Future<List<PostModel>> getPostsByUserId(String userId) async {
    final posts = await getPosts();
    return posts.where((post) => post.userId == userId).toList();
  }

  Future<void> addPost(PostModel post) async {
    final prefs = await SharedPreferences.getInstance();
    final postsJson = prefs.getStringList(_localPostsKey) ?? [];

    postsJson.insert(
      0,
      jsonEncode(post.toJson()),
    );

    await prefs.setStringList(_localPostsKey, postsJson);
  }

  Future<void> clearLocalPosts() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_localPostsKey);
  }
}