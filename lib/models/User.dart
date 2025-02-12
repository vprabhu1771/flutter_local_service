class User {
  String name;
  String email;
  String avatar;
  String image_path;

  User(
      {required this.name,
        required this.email,
        required this.avatar,
        required this.image_path});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        image_path = json['image_path'];
}
