class LevelModel {
  int id;
  String name;

  LevelModel({required this.id, required this.name});

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'],
      name: json['name'],
    );
  }
}
