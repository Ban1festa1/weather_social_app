import '../models/app_user_model.dart';

class UserRepository {
  AppUserModel getCurrentUser() {
    return const AppUserModel(
      id: 'current_user',
      name: 'Мой пользователь',
      email: 'user@example.com',
      city: 'Москва',
    );
  }

  List<AppUserModel> getUsers() {
    return [
      getCurrentUser(),
      const AppUserModel(
        id: 'user_1',
        name: 'Алина',
        email: 'alina@example.com',
        city: 'Москва',
      ),
      const AppUserModel(
        id: 'user_2',
        name: 'Игорь',
        email: 'igor@example.com',
        city: 'Санкт-Петербург',
      ),
      const AppUserModel(
        id: 'user_3',
        name: 'Марина',
        email: 'marina@example.com',
        city: 'Казань',
      ),
    ];
  }

  AppUserModel? getUserById(String id) {
    final users = getUsers();

    try {
      return users.firstWhere((user) => user.id == id);
    } catch (_) {
      return null;
    }
  }
}