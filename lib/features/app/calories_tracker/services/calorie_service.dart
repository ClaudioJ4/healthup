import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthup/features/app/calories_tracker/models/meal.dart';

Future<void> addMeal(String userId, Meal meal) async {
  final date = DateTime.now().toString().substring(0, 10);
  final dailyCaloriesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('dailyCalories')
      .doc(date);

  await dailyCaloriesRef.collection('meals').add(meal.toMap());

  final doc = await dailyCaloriesRef.get();
  if (doc.exists) {
    final data = doc.data()!;
    final totalCalories = data['totalCalories'] + meal.calories;
    await dailyCaloriesRef.update({'totalCalories': totalCalories});
  } else {
    await dailyCaloriesRef.set({
      'totalCalories': meal.calories,
      'goalCalories': 2000, // default value, can be adjusted later
    });
  }
}

Future<void> updateGoalCalories(String userId, int newGoal) async {
  final date = DateTime.now().toString().substring(0, 10);
  final dailyCaloriesRef = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('dailyCalories')
      .doc(date);

  await dailyCaloriesRef.update({'goalCalories': newGoal});
}
