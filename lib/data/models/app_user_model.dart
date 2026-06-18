class AppUserModel {
  final String id;
  final String name;
  final String email;
  final String city;
  final String? avatarPath;

  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.city,
    this.avatarPath,
  });

  factory AppUserModel.fromJson(Map<String, dynamic> json) {
    return AppUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      city: json['city'] as String,
      avatarPath: json['avatarPath'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'city': city,
      'avatarPath': avatarPath,
    };
  }
}