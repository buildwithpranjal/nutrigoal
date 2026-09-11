import 'package:flutter/foundation.dart';
import '../models/models.dart';

/// The single source of truth for the app.
///
/// This is what ties Feature 1 (Goal -> Dashboard targets) and
/// Feature 2 (Log Food -> Meal Plan totals) together: both screens
/// read from and write to this same notifier, so a change in one
/// screen is immediately reflected on the others.
class AppState extends ChangeNotifier {
  GoalType? _selectedGoal;
  final List<FoodEntry> _entries = [];
  final List<FoodItem> _customFoods = [];
  int _idCounter = 0;

  GoalType? get selectedGoal => _selectedGoal;
  bool get hasGoal => _selectedGoal != null;
  List<FoodEntry> get entries => List.unmodifiable(_entries);
  List<FoodItem> get customFoods => List.unmodifiable(_customFoods);

  void selectGoal(GoalType goal) {
    _selectedGoal = goal;
    notifyListeners();
  }

  /// Daily calorie + macro targets, derived from the selected goal.
  MacroTargets get targets {
    const baseline = 2000.0;
    switch (_selectedGoal ?? GoalType.maintainWeight) {
      case GoalType.loseWeight:
        final cal = baseline * 0.80;
        return MacroTargets(
          calories: cal,
          proteinG: (cal * 0.35) / 4,
          carbsG: (cal * 0.35) / 4,
          fatG: (cal * 0.30) / 9,
        );
      case GoalType.gainMuscle:
        final cal = baseline * 1.15;
        return MacroTargets(
          calories: cal,
          proteinG: (cal * 0.30) / 4,
          carbsG: (cal * 0.45) / 4,
          fatG: (cal * 0.25) / 9,
        );
      case GoalType.improveHealth:
        final cal = baseline * 0.95;
        return MacroTargets(
          calories: cal,
          proteinG: (cal * 0.25) / 4,
          carbsG: (cal * 0.45) / 4,
          fatG: (cal * 0.30) / 9,
        );
      case GoalType.maintainWeight:
        return MacroTargets(
          calories: baseline,
          proteinG: (baseline * 0.25) / 4,
          carbsG: (baseline * 0.50) / 4,
          fatG: (baseline * 0.25) / 9,
        );
    }
  }

  void logFood(FoodItem food, MealType meal, double servings) {
    _entries.add(FoodEntry(
      id: 'entry_${_idCounter++}',
      food: food,
      mealType: meal,
      servings: servings,
      loggedAt: DateTime.now(),
    ));
    notifyListeners();
  }

  void removeEntry(String id) {
    _entries.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  /// Adds a user-defined food to the catalogue so it shows up under
  /// "My foods" on the Log Food screen and can be logged like any
  /// other item.
  FoodItem addCustomFood({
    required String name,
    required String servingLabel,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) {
    final food = FoodItem(
      id: 'custom_${_idCounter++}',
      name: name,
      servingLabel: servingLabel.isEmpty ? '1 serving' : servingLabel,
      caloriesPerServing: calories,
      proteinG: protein,
      carbsG: carbs,
      fatG: fat,
      isCustom: true,
    );
    _customFoods.add(food);
    notifyListeners();
    return food;
  }

  List<FoodEntry> entriesForMeal(MealType meal) =>
      _entries.where((e) => e.mealType == meal).toList();

  double _sum(double Function(FoodEntry) selector) =>
      _entries.fold(0.0, (sum, e) => sum + selector(e));

  double get consumedCalories => _sum((e) => e.calories);
  double get consumedProtein => _sum((e) => e.protein);
  double get consumedCarbs => _sum((e) => e.carbs);
  double get consumedFat => _sum((e) => e.fat);

  double get remainingCalories =>
      (targets.calories - consumedCalories).clamp(0, targets.calories);

  double get calorieProgress =>
      targets.calories == 0 ? 0 : (consumedCalories / targets.calories).clamp(0.0, 1.0);

  /// Static, non-persisted values purely to match the Progress screen's
  /// visual design (streak days, goal-hit rate). Not wired to real
  /// history since that is out of scope for this front-end assessment.
  int get streakDays => 12;
  double get goalHitRate => 0.86;
}
