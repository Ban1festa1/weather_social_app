import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepository {
  static const String _avatarPathKey = 'profile_avatar_path';

  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> getAvatarPath() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString(_avatarPathKey);

    if (avatarPath == null) {
      return null;
    }

    final avatarFile = File(avatarPath);

    if (await avatarFile.exists()) {
      return avatarPath;
    }

    await prefs.remove(_avatarPathKey);
    return null;
  }

  Future<String?> pickAndSaveAvatar() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedImage == null) {
      return null;
    }

    final appDirectory = await getApplicationDocumentsDirectory();

    final extension = pickedImage.name.contains('.')
        ? pickedImage.name.split('.').last
        : 'jpg';

    final savedImagePath =
        '${appDirectory.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.$extension';

    final savedImage = await File(pickedImage.path).copy(savedImagePath);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, savedImage.path);

    return savedImage.path;
  }

  Future<void> deleteAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final avatarPath = prefs.getString(_avatarPathKey);

    if (avatarPath != null) {
      final avatarFile = File(avatarPath);

      if (await avatarFile.exists()) {
        await avatarFile.delete();
      }
    }

    await prefs.remove(_avatarPathKey);
  }
}