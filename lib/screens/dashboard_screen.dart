import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/progress_ring.dart';
import 'coach_screen.dart';

/// Pixel-matched to the Figma CSS export for screen 04 (Dashboard).
///
/// Mapping from design to real data: the ring's big number and "kcal
/// left" label show *remaining* calories (target - consumed), matching
/// the spec's worked example (Goal 1,800; Food 560; ring shows 1,240
/// left = 1800 - 560). "Exercise" is not tracked in this build and
/// always shows +0.
class DashboardScreen extends StatelessWidget {
  final VoidCallback onViewMealPlan;
  const DashboardScreen({super.key, required this.onViewMealPlan});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final targets = state.targets;
        final consumed = state.consumedCalories;
        final remaining = state.remainingCalories;
        final fraction = state.calorieProgress;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
              children: [
                // Header: greeting + bell
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good morning,', style: AppText.body(size: 13, color: AppColors.textGrey)),
                          Text('Rahul 👋', style: AppText.display(size: 22, weight: FontWeight.w800)),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CoachScreen()),
                        ),
                        child: Container(
                          width: 44,
                          height: 22,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: AppColors.controlBorder),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(Icons.notifications_none, size: 16, color: AppColors.textDark),
                        ),
                      ),
                    ],
                  ),
                ),
                // Ring card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: softCard(radius: 24),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProgressRing(
                            fraction: fraction,
                            size: 120,
                            strokeWidth: 12,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_fmt(remaining), style: AppText.display(size: 28, weight: FontWeight.w800)),
                                Text('kcal left', style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _statLine('GOAL', AppColors.textGrey, _fmt(targets.calories)),
                                const SizedBox(height: 9),
                                _statLine('FOOD', AppColors.carbs, _fmt(consumed)),
                                const SizedBox(height: 9),
                                _statLine('EXERCISE', AppColors.primaryGreen, '+0'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 11, 5),
                          decoration: BoxDecoration(color: AppColors.cardTint, borderRadius: BorderRadius.circular(99)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(width: 7, height: 7, decoration: const BoxDecoration(color: AppColors.primaryGreen, shape: BoxShape.circle)),
                              const SizedBox(width: 6),
                              Text('On track today', style: AppText.body(size: 12, weight: FontWeight.w700, color: AppColors.successText)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Divider(color: AppColors.controlBorder, height: 1),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: _MacroColumn(label: 'Protein', value: state.consumedProtein, target: targets.proteinG, color: AppColors.primaryGreen)),
                          const SizedBox(width: 16),
                          Expanded(child: _MacroColumn(label: 'Carbs', value: state.consumedCarbs, target: targets.carbsG, color: AppColors.carbs)),
                          const SizedBox(width: 16),
                          Expanded(child: _MacroColumn(label: 'Fat', value: state.consumedFat, target: targets.fatG, color: AppColors.fat)),
                        ],
                      ),
                    ],
                  ),
                ),
                // Today's meals header
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Row(
                    children: [
                      Text("Today's meals", style: AppText.display(size: 18, weight: FontWeight.w800)),
                      const Spacer(),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                        onPressed: onViewMealPlan,
                        child: Text('See plan', style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.primaryGreen)),
                      ),
                    ],
                  ),
                ),
                for (final meal in MealType.values) ...[
                  _MealTile(meal: meal),
                  const SizedBox(height: 10),
                ],
                const SizedBox(height: 8),
                // Coach tip card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(color: AppColors.coachDark, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('💬 Coach tip', style: AppText.display(size: 15, weight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 6),
                      Text(
                        "You've hit your protein goal 4 days running, nice. Add 10g at dinner to stay ahead this week.",
                        style: AppText.body(size: 13.5, color: AppColors.coachBody, height: 1.45),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _fmt(double v) {
    final rounded = v.round();
    final s = rounded.toString();
    if (s.length <= 3) return s;
    final buffer = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buffer.write(',');
      buffer.write(s[i]);
    }
    return buffer.toString();
  }

  Widget _statLine(String label, Color labelColor, String value) {
    return Row(
      children: [
        Text(label, style: AppText.body(size: 11, weight: FontWeight.w700, color: labelColor).copyWith(letterSpacing: 0.5)),
        const Spacer(),
        Text(value, style: AppText.body(size: 15, weight: FontWeight.w800, color: AppColors.textDark)),
      ],
    );
  }
}

class _MacroColumn extends StatelessWidget {
  final String label;
  final double value;
  final double target;
  final Color color;
  const _MacroColumn({required this.label, required this.value, required this.target, required this.color});

  @override
  Widget build(BuildContext context) {
    final fraction = target == 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 7,
          decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(6)),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: fraction,
            child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
          ),
        ),
        const SizedBox(height: 7),
        Text(label, style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textGrey)),
        Text('${value.round()}/${target.round()}g', style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textDark)),
      ],
    );
  }
}

class _MealTile extends StatelessWidget {
  final MealType meal;
  const _MealTile({required this.meal});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        final items = state.entriesForMeal(meal);
        final calories = items.fold<double>(0, (s, e) => s + e.calories);
        final subtitle = items.isEmpty
            ? 'Nothing logged yet'
            : items.length == 1
                ? '${items.first.food.name} · ${calories.round()} kcal'
                : '${items.length} items · ${calories.round()} kcal';

        return Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          decoration: softCard(radius: 18),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(12)),
                child: Text(meal.emoji, style: const TextStyle(fontSize: 18)),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(meal.label, style: AppText.body(size: 15, weight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: AppText.body(size: 12.5, color: AppColors.textGrey), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              if (items.isNotEmpty)
                Container(
                  width: 28,
                  height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.doneGreen, borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                )
              else
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.controlBorder, width: 2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
