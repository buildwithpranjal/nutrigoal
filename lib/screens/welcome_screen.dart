import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'login_screen.dart';
import 'goal_screen.dart';

/// Pixel-matched to the Figma CSS export for screen 01 (Welcome).
/// Fixed values below (52, 44, 22, 24, 13, 16, 187, 342...) are taken
/// directly from that export, not estimated from a thumbnail.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 24),
              // Logo mark: 96x52 green pill, radius 30, white ring icon.
              Container(
                width: 96,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(30),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.track_changes, color: Colors.white, size: 28),
              ),
              const SizedBox(height: 14),
              Text('NutriGoal', style: AppText.display(size: 34, weight: FontWeight.w800)),
              const SizedBox(height: 14),
              SizedBox(
                width: 250,
                child: Text(
                  'Your personal diet coach - a plan that adapts to your goal, every single day.',
                  textAlign: TextAlign.center,
                  style: AppText.body(size: 15, color: AppColors.textGrey, height: 1.4),
                ),
              ),
              const SizedBox(height: 38),
              // Feature card: 342 wide, 187 tall, tint background, radius 24.
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 342),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: AppColors.cardTint,
                  border: Border.all(color: AppColors.cardBorder),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    _FeatureRow(emoji: '🎯', title: 'Set your goal', subtitle: 'Lose, maintain, or gain - your call'),
                    const SizedBox(height: 16),
                    _FeatureRow(emoji: '🥗', title: 'Get a smart plan', subtitle: 'Meals built to hit your targets'),
                    const SizedBox(height: 16),
                    _FeatureRow(emoji: '📈', title: 'Track & adapt', subtitle: 'The coach tunes your plan weekly'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const GoalScreen()),
                  ),
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: TextButton(
                  style: TextButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
                  child: Text('I already have an account',
                      style: AppText.body(size: 16, weight: FontWeight.w600, color: AppColors.textGrey)),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _FeatureRow({required this.emoji, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Emoji chip: 44x22 white pill, radius 13, hairline border.
        Container(
          width: 44,
          height: 22,
          alignment: Alignment.center,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: AppColors.cardBorder),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: AppText.body(size: 15, weight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(subtitle, style: AppText.body(size: 12.5, color: AppColors.textGrey)),
            ],
          ),
        ),
      ],
    );
  }
}
