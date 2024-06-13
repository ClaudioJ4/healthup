class WaterIntake {
  String id;
  int totalWaterIntake;
  int goalWaterIntake;

  WaterIntake(
      {required this.id,
      required this.totalWaterIntake,
      required this.goalWaterIntake});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'totalWaterIntake': totalWaterIntake,
      'goalWaterIntake': goalWaterIntake,
    };
  }

  static WaterIntake fromMap(Map<String, dynamic> map, String documentId) {
    return WaterIntake(
      id: documentId,
      totalWaterIntake: map['totalWaterIntake'],
      goalWaterIntake: map['goalWaterIntake'],
    );
  }
}
