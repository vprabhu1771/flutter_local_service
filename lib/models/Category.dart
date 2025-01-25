class Category {

  int id;
  String name;
  String icon_path;


  Category({
    required this.id,
    required this.name,
    required this.icon_path
  });

  Category.fromJson(Map<String, dynamic> json):
        id = json['id'],
        name = json['name'],
        icon_path = json['icon_path'];
}
