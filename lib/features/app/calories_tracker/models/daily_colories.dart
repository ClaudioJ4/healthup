import 'package:healthup/features/app/calories_tracker/models/meal.dart';

class DailyCalories {
  int totalCalories;
  int goalCalories;
  List<Meal> meals;

  DailyCalories(
      {required this.totalCalories,
      required this.goalCalories,
      required this.meals});

  Map<String, dynamic> toMap() {
    return {
      'totalCalories': totalCalories,
      'goalCalories': goalCalories,
      'meals': meals.map((meal) => meal.toMap()).toList(),
    };
  }

  static DailyCalories fromMap(Map<String, dynamic> map) {
    return DailyCalories(
      totalCalories: map['totalCalories'],
      goalCalories: map['goalCalories'],
      meals: (map['meals'] as List)
          .map((mealMap) => Meal.fromMap(mealMap, mealMap['id']))
          .toList(),
    );
  }
}
