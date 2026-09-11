import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/weight_chart.dart';

/// Pixel-matched to the Figma CSS export for screen 08 (Progress).
/// Weight history is static sample data (no weight-logging feature
/// exists in this build, see report section 5); the week's averages
/// use real logged data.
class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  static const _sampleWeights = [74.0, 73.5, 73.0, 72.4, 71.8, 71.2];
  static const _goalWeight = 66.0;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Progress', style: AppText.display(size: 24, weight: FontWeight.w800)),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                  decoration: softCard(radius: 20),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('CURRENT WEIGHT',
                                  style: AppText.body(size: 11, weight: FontWeight.w700, color: AppColors.textGrey).copyWith(letterSpacing: 0.5)),
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('${_sampleWeights.last}', style: AppText.display(size: 30, weight: FontWeight.w800)),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Text('kg', style: AppText.body(size: 15, weight: FontWeight.w600, color: AppColors.textGrey)),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.fromLTRB(10, 6, 11, 6),
                            decoration: BoxDecoration(color: AppColors.cardTint, borderRadius: BorderRadius.circular(99)),
                            child: Text('▼ ${(_sampleWeights.first - _sampleWeights.last).toStringAsFixed(1)} kg',
                                style: AppText.body(size: 12, weight: FontWeight.w700, color: AppColors.successText)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      WeightChart(values: _sampleWeights, goalValue: _goalWeight),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Wk 1', style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
                          Text('Now', style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
                          Text('Goal ${_goalWeight.round()}', style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _statCard('🔥', '${state.streakDays}', 'day streak')),
                    const SizedBox(width: 12),
                    Expanded(child: _statCard('✅', '${(state.goalHitRate * 100).round()}%', 'goal days')),
                  ],
                ),
                const SizedBox(height: 18),
                Text("This week's averages", style: AppText.display(size: 18, weight: FontWeight.w800)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: softCard(radius: 18),
                  child: Column(
                    children: [
                      _avgRow('Calories', state.consumedCalories, state.targets.calories, AppColors.textDark),
                      const SizedBox(height: 16),
                      _avgRow('Protein', state.consumedProtein, state.targets.proteinG, AppColors.primaryGreen),
                      const SizedBox(height: 16),
                      _avgRow('Carbs', state.consumedCarbs, state.targets.carbsG, AppColors.carbs),
                      const SizedBox(height: 16),
                      _avgRow('Fat', state.consumedFat, state.targets.fatG, AppColors.fat),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statCard(String emoji, String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: softCard(radius: 18),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 3),
          Text(value, style: AppText.display(size: 24, weight: FontWeight.w800)),
          Text(label, style: AppText.body(size: 12, weight: FontWeight.w600, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _avgRow(String label, double value, double target, Color color) {
    final fraction = target == 0 ? 0.0 : (value / target).clamp(0.0, 1.0);
    return Row(
      children: [
        SizedBox(width: 60, child: Text(label, style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.labelDark))),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 7,
            decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(6)),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: fraction,
              child: Container(decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6))),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text('${value.round()}/${target.round()}${label == 'Calories' ? '' : 'g'}',
            style: AppText.body(size: 12, weight: FontWeight.w700)),
      ],
    );
  }
}
