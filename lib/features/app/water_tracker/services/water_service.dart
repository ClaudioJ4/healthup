import 'package:cloud_firestore/cloud_firestore.dart';

class WaterService {
  final String userId;

  WaterService(this.userId);

  Future<void> addWater(int ml) async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final waterRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyWaterIntake')
        .doc(date);

    final doc = await waterRef.get();
    if (doc.exists) {
      final data = doc.data()!;
      final totalWaterIntake = data['totalWaterIntake'] + ml;
      await waterRef.update({'totalWaterIntake': totalWaterIntake});
    } else {
      await waterRef.set({
        'totalWaterIntake': ml,
        'goalWaterIntake': 2000,
      });
    }
  }

  Future<void> setGoal(int goal) async {
    final date = DateTime.now().toIso8601String().substring(0, 10);
    final waterRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('dailyWaterIntake')
        .doc(date);

    final doc = await waterRef.get();
    if (doc.exists) {
      await waterRef.update({'goalWaterIntake': goal});
    } else {
      await waterRef.set({
        'totalWaterIntake': 0,
        'goalWaterIntake': goal,
      });
    }
  }
}
