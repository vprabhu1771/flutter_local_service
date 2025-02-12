class ServiceProvider {

  final int id;
  final String name;
  final String email;
  final String avatar;
  final String? imagePath;
  final String? phone;
  final String serviceStatus;

  ServiceProvider({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.imagePath,
    this.phone,
    required this.serviceStatus,
  });

  ServiceProvider.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        email = json['email'],
        avatar = json['avatar'],
        imagePath = json['imagePath'],
        phone = json['phone'],
        serviceStatus = json['service_status'];
}
