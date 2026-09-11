import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Pixel-matched to the Figma CSS export for screen 06 (Meal Detail).
///
/// Two entry points, matching two real situations in the app:
/// - `.existing(entry)`: viewing something already logged -> shows its
///   actual servings/macros, button reads "Remove from log".
/// - `.suggestion(food, mealType)`: viewing a not-yet-logged suggested
///   item from the Meal Plan -> shows base macros, button reads
///   "Log this meal" (matching the spec's exact copy) and logs it.
class MealDetailScreen extends StatefulWidget {
  final FoodEntry? existingEntry;
  final FoodItem? suggestedFood;
  final MealType? suggestedMealType;

  const MealDetailScreen.existing({super.key, required FoodEntry entry})
      : existingEntry = entry,
        suggestedFood = null,
        suggestedMealType = null;

  const MealDetailScreen.suggestion({super.key, required FoodItem food, required MealType mealType})
      : existingEntry = null,
        suggestedFood = food,
        suggestedMealType = mealType;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  bool _favorited = false;

  bool get _isExisting => widget.existingEntry != null;

  FoodItem get _food => widget.existingEntry?.food ?? widget.suggestedFood!;
  MealType get _mealType => widget.existingEntry?.mealType ?? widget.suggestedMealType!;
  double get _servings => widget.existingEntry?.servings ?? 1;
  double get _calories => widget.existingEntry?.calories ?? _food.caloriesPerServing;
  double get _protein => widget.existingEntry?.protein ?? _food.proteinG;
  double get _carbs => widget.existingEntry?.carbs ?? _food.carbsG;
  double get _fat => widget.existingEntry?.fat ?? _food.fatG;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 220,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 220,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.cardTint, AppColors.peachTint],
                      ),
                    ),
                    alignment: Alignment.center,
                    child: const Text('🥗', style: TextStyle(fontSize: 96)),
                  ),
                  Positioned(
                    top: 14,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 42,
                        height: 20,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.arrow_back_ios_new, size: 12, color: AppColors.textDark),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 14,
                    right: 16,
                    child: GestureDetector(
                      onTap: () => setState(() => _favorited = !_favorited),
                      child: Container(
                        width: 42,
                        height: 18,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(_favorited ? '❤' : '🤍', style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_mealType.label.toUpperCase()} · ${_isExisting ? 'LOGGED' : 'SUGGESTED'}',
                    style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textGrey).copyWith(letterSpacing: 0.66),
                  ),
                  const SizedBox(height: 4),
                  Text(_food.name, style: AppText.display(size: 26, weight: FontWeight.w800)),
                  const SizedBox(height: 6),
                  Text(
                    _isExisting
                        ? '${_servings} x ${_food.servingLabel}'
                        : "Fits today's remaining macros for ${_mealType.label.toLowerCase()}.",
                    style: AppText.body(size: 14, color: AppColors.textGrey, height: 1.45),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(child: _macroBox(_calories.round().toString(), 'kcal', AppColors.textDark)),
                      const SizedBox(width: 10),
                      Expanded(child: _macroBox('${_protein.round()}g', 'protein', AppColors.primaryGreen)),
                      const SizedBox(width: 10),
                      Expanded(child: _macroBox('${_carbs.round()}g', 'carbs', AppColors.carbs)),
                      const SizedBox(width: 10),
                      Expanded(child: _macroBox('${_fat.round()}g', 'fat', AppColors.fat)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Text('Ingredients', style: AppText.display(size: 18, weight: FontWeight.w800)),
                  const SizedBox(height: 8),
                  if (_food.ingredients.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text('No ingredient breakdown for this item.', style: AppText.body(color: AppColors.textGrey)),
                    )
                  else
                    ..._food.ingredients.map((i) => Container(
                          padding: const EdgeInsets.symmetric(vertical: 11),
                          decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
                          child: Row(
                            children: [
                              const Icon(Icons.check_circle_outline, size: 18, color: AppColors.primaryGreen),
                              const SizedBox(width: 11),
                              Expanded(child: Text(i, style: AppText.body(size: 14, weight: FontWeight.w500, color: AppColors.labelDark))),
                            ],
                          ),
                        )),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 30),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.controlBorder)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Container(
                width: 54,
                height: 20,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: AppColors.controlBorder),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text('🛒', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    style: _isExisting ? ElevatedButton.styleFrom(backgroundColor: AppColors.textDark) : null,
                    onPressed: () {
                      if (_isExisting) {
                        context.read<AppState>().removeEntry(widget.existingEntry!.id);
                      } else {
                        context.read<AppState>().logFood(_food, _mealType, 1);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(_isExisting ? 'Remove from log' : 'Log this meal'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _macroBox(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border.all(color: AppColors.cardBorder),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(value, style: AppText.display(size: 19, weight: FontWeight.w800, color: color)),
          Text(label, style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
        ],
      ),
    );
  }
}
