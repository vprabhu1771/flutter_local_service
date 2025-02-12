class Service {

  int id;
  String name;
  String description;
  String availability_status;


  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.availability_status
  });

  Service.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        description = json['description'],
        availability_status = json['availability_status'];
}
