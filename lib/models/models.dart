import 'package:flutter/material.dart';

/// The four goals offered on the "What's your main goal?" screen.
enum GoalType { loseWeight, maintainWeight, gainMuscle, improveHealth }

extension GoalTypeX on GoalType {
  String get label {
    switch (this) {
      case GoalType.loseWeight:
        return 'Lose weight';
      case GoalType.maintainWeight:
        return 'Maintain weight';
      case GoalType.gainMuscle:
        return 'Gain muscle';
      case GoalType.improveHealth:
        return 'Improve health';
    }
  }

  String get description {
    switch (this) {
      case GoalType.loseWeight:
        return 'Gradual, sustainable fat loss';
      case GoalType.maintainWeight:
        return 'Stay steady & build habits';
      case GoalType.gainMuscle:
        return 'Lean bulk with higher protein';
      case GoalType.improveHealth:
        return 'Eat better, feel better';
    }
  }

  IconData get icon {
    switch (this) {
      case GoalType.loseWeight:
        return Icons.trending_down;
      case GoalType.maintainWeight:
        return Icons.balance;
      case GoalType.gainMuscle:
        return Icons.fitness_center;
      case GoalType.improveHealth:
        return Icons.favorite_border;
    }
  }

  /// Emoji glyph used on the Goal screen's option chips, matching the
  /// exact Figma export.
  String get emoji {
    switch (this) {
      case GoalType.loseWeight:
        return '🔻';
      case GoalType.maintainWeight:
        return '⚖️';
      case GoalType.gainMuscle:
        return '💪';
      case GoalType.improveHealth:
        return '❤️';
    }
  }
}

/// Daily calorie + macro targets derived from a goal.
class MacroTargets {
  final double calories;
  final double proteinG;
  final double carbsG;
  final double fatG;

  const MacroTargets({
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });
}

/// A food that can be logged. `ingredients` is only populated for
/// composite "meal" style items (e.g. the salad shown in the prototype).
/// `isCustom` marks foods the user created themselves via "Add your own food".
class FoodItem {
  final String id;
  final String name;
  final String servingLabel;
  final double caloriesPerServing;
  final double proteinG;
  final double carbsG;
  final double fatG;
  final List<String> ingredients;
  final bool isCustom;

  const FoodItem({
    required this.id,
    required this.name,
    required this.servingLabel,
    required this.caloriesPerServing,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
    this.ingredients = const [],
    this.isCustom = false,
  });
}

enum MealType { breakfast, lunch, dinner, snack }

extension MealTypeX on MealType {
  String get label {
    switch (this) {
      case MealType.breakfast:
        return 'Breakfast';
      case MealType.lunch:
        return 'Lunch';
      case MealType.dinner:
        return 'Dinner';
      case MealType.snack:
        return 'Snack';
    }
  }

  IconData get icon {
    switch (this) {
      case MealType.breakfast:
        return Icons.wb_sunny_outlined;
      case MealType.lunch:
        return Icons.lunch_dining;
      case MealType.dinner:
        return Icons.dinner_dining;
      case MealType.snack:
        return Icons.cookie_outlined;
    }
  }

  /// Emoji glyph used on the Dashboard's meal-icon chips, matching the
  /// exact Figma export (all chips share a neutral background; only the
  /// emoji differs).
  String get emoji {
    switch (this) {
      case MealType.breakfast:
        return '🥣';
      case MealType.lunch:
        return '🥗';
      case MealType.dinner:
        return '🍽️';
      case MealType.snack:
        return '🍎';
    }
  }
}

/// A single logged instance of a food, tied to a meal of the day.
class FoodEntry {
  final String id;
  final FoodItem food;
  final MealType mealType;
  final double servings;
  final DateTime loggedAt;

  FoodEntry({
    required this.id,
    required this.food,
    required this.mealType,
    required this.servings,
    required this.loggedAt,
  });

  double get calories => food.caloriesPerServing * servings;
  double get protein => food.proteinG * servings;
  double get carbs => food.carbsG * servings;
  double get fat => food.fatG * servings;
}
