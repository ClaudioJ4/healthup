class Meal {
  String id;
  String name;
  int calories;

  Meal({required this.id, required this.name, required this.calories});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
    };
  }

  static Meal fromMap(Map<String, dynamic> map, String documentId) {
    return Meal(
      id: documentId,
      name: map['name'],
      calories: map['calories'],
    );
  }
}
