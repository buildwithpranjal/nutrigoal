import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/food_catalog.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import 'meal_detail_screen.dart';

/// Pixel-matched to the Figma CSS export for screen 05 (Meal Plan).
///
/// Where the design shows a fixed suggested plan (e.g. "Oats & mixed
/// berries · 420 kcal"), this build shows that suggestion until the
/// user has actually logged something for that meal, then switches to
/// showing what they logged, with a live running total. The day
/// selector and "Regenerate" affordance are visual-only (no meal
/// generation engine exists in this build).
class MealPlanScreen extends StatefulWidget {
  const MealPlanScreen({super.key});

  @override
  State<MealPlanScreen> createState() => _MealPlanScreenState();
}

class _MealPlanScreenState extends State<MealPlanScreen> {
  int _selectedDay = 2; // Wednesday, matching the spec's example

  static const _dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  static const _dayNumbers = [10, 11, 12, 13, 14];

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final targets = state.targets;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Text('Meal Plan', style: AppText.display(size: 24, weight: FontWeight.w800)),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Regenerating a plan is not available in this build.')),
                        ),
                        child: Container(
                          height: 34,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.controlBorder),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.refresh, size: 14, color: AppColors.textDark),
                              const SizedBox(width: 6),
                              Text('Regenerate', style: AppText.body(size: 13, weight: FontWeight.w600)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (int i = 0; i < 5; i++) ...[
                      Expanded(child: _dayBox(i)),
                      if (i < 4) const SizedBox(width: 6),
                    ],
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('WEDNESDAY · PLANNED',
                              style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textGrey).copyWith(letterSpacing: 0.4)),
                          Text('${targets.calories.round()} kcal', style: AppText.body(size: 15, weight: FontWeight.w800)),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'P ${targets.proteinG.round()} · C ${targets.carbsG.round()} · F ${targets.fatG.round()}g',
                        style: AppText.body(size: 12, weight: FontWeight.w600, color: AppColors.textGrey),
                      ),
                    ],
                  ),
                ),
                for (final meal in MealType.values) ...[
                  _MealCard(meal: meal),
                  const SizedBox(height: 14),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dayBox(int i) {
    final selected = i == _selectedDay;
    return GestureDetector(
      onTap: () => setState(() => _selectedDay = i),
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.textDark : Colors.white,
          border: Border.all(color: selected ? AppColors.textDark : AppColors.controlBorder),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_dayLabels[i], style: AppText.body(size: 11, weight: FontWeight.w700, color: selected ? Colors.white : AppColors.textGrey)),
            Text('${_dayNumbers[i]}', style: AppText.display(size: 17, weight: FontWeight.w800, color: selected ? Colors.white : AppColors.textDark)),
          ],
        ),
      ),
    );
  }
}

class _MealCard extends StatelessWidget {
  final MealType meal;
  const _MealCard({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.entriesForMeal(meal);
        final hasLogged = items.isNotEmpty;
        final suggestion = suggestedMeal[meal]!;

        final String name = hasLogged
            ? (items.length == 1 ? items.first.food.name : '${items.length} items logged')
            : suggestion.name;
        final double calories = hasLogged ? items.fold<double>(0, (s, e) => s + e.calories) : suggestion.caloriesPerServing;
        final double protein = hasLogged ? items.fold<double>(0, (s, e) => s + e.protein) : suggestion.proteinG;

        return Container(
          padding: const EdgeInsets.all(14),
          decoration: softCard(radius: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(meal.label.toUpperCase(),
                  style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textGrey).copyWith(letterSpacing: 0.66)),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(14)),
                    child: Text(meal.emoji, style: const TextStyle(fontSize: 20)),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(name, style: AppText.body(size: 15, weight: FontWeight.w700), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 3),
                        Text('${calories.round()} kcal · ${protein.round()}g protein',
                            style: AppText.body(size: 12.5, color: AppColors.textGrey)),
                        const SizedBox(height: 3),
                        GestureDetector(
                          onTap: () => _handleAction(context, hasLogged, items, suggestion),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(hasLogged ? Icons.chevron_right : Icons.add, size: 14, color: AppColors.primaryGreen),
                              const SizedBox(width: 5),
                              Text(hasLogged ? 'View meal' : 'Add meal',
                                  style: AppText.body(size: 12.5, weight: FontWeight.w700, color: AppColors.primaryGreen)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.controlBorder, width: 2),
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleAction(BuildContext context, bool hasLogged, List<FoodEntry> items, FoodItem suggestion) {
    if (hasLogged) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MealDetailScreen.existing(entry: items.first)),
      );
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => MealDetailScreen.suggestion(food: suggestion, mealType: meal)),
      );
    }
  }
}
