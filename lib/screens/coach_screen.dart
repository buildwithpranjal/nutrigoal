import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Pixel-matched to the Figma CSS export for screen 09 (Coach).
/// Content is static (no rules engine exists in this build to
/// generate real personalised nudges, see report section 5).
class CoachScreen extends StatelessWidget {
  const CoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Coach', style: AppText.display(size: 24, weight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text('Adaptive insights, updated daily.', style: AppText.body(size: 14, color: AppColors.textGrey)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.coachDark, AppColors.primaryGreen],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('📊 Weekly check-in', style: AppText.display(size: 16, weight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 6),
                  Text(
                    "You averaged 1,720 kcal, right in your target zone. On this pace you'll reach 66 kg about 1 week early. Keep going!",
                    style: AppText.body(size: 13.5, color: AppColors.coachBody, height: 1.5),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            _InsightCard(
              emoji: '🥩',
              title: 'Nudge: protein at breakfast',
              body: 'Your mornings are carb-heavy. Adding eggs or yogurt would smooth your energy and hit protein earlier.',
              actionLabel: 'Apply to plan',
            ),
            const SizedBox(height: 14),
            const _InsightCard(
              emoji: '💧',
              title: 'Hydration is trending up',
              body: '6 glasses/day this week vs 4 last week. Small wins compound.',
            ),
            const SizedBox(height: 14),
            const _InsightCard(
              emoji: '🎯',
              title: 'Plan adjusted for next week',
              body: 'As you get lighter, your calorie target drops slightly to 1,760 kcal to keep progress steady.',
              background: AppColors.peachTint,
            ),
          ],
        ),
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final String emoji;
  final String title;
  final String body;
  final String? actionLabel;
  final Color? background;

  const _InsightCard({
    required this.emoji,
    required this.title,
    required this.body,
    this.actionLabel,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: background != null
          ? BoxDecoration(color: background, borderRadius: BorderRadius.circular(18))
          : softCard(radius: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppText.body(size: 15, weight: FontWeight.w800)),
                const SizedBox(height: 5),
                Text(body, style: AppText.body(size: 13.5, color: AppColors.labelDark, height: 1.45)),
                if (actionLabel != null) ...[
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.controlBorder),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(actionLabel!, style: AppText.body(size: 12.5, weight: FontWeight.w700)),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
