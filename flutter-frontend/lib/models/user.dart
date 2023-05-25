class UserModel {
  int? id;
  String? name;
  String? email;
  String? password;
  int? levelId;
  String? level;
  String? image;

  UserModel({this.id, required this.name, required this.email, required this.levelId, this.password, this.level, this.image});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json.containsKey('password') ? json['password'] : '',
      levelId: json['level_id'],
      image: json.containsKey('image') ? json['image'] : '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'email': email,
      'password': password,
      'level_id': levelId,
    };

    if (image != null) {
      json['image'] = image;
    }

    return json;
  }
}
