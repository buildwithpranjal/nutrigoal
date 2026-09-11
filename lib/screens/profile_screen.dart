import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

/// Pixel-matched to the Figma CSS export for screen 10 (Profile).
/// Menu rows and "Log out" are visual-only (no account/auth system
/// exists in this build, see report section 5).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                  child: Text('Profile', style: AppText.display(size: 24, weight: FontWeight.w800)),
                ),
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: softCard(radius: 22),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 26,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(29),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [AppColors.avatarGradientStart, AppColors.primaryGreen],
                              ),
                            ),
                            child: Text('R', style: AppText.display(size: 22, weight: FontWeight.w800, color: AppColors.avatarTextDark)),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Rahul Chettri', style: AppText.body(size: 18, weight: FontWeight.w800)),
                                const SizedBox(height: 3),
                                Text('Goal: ${state.selectedGoal?.label ?? '-'} · 66 kg',
                                    style: AppText.body(size: 13, color: AppColors.textGrey)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: AppColors.controlBorder),
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: Text('Edit goal', style: AppText.body(size: 13, weight: FontWeight.w700)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _statBox('74→71', 'kg')),
                          const SizedBox(width: 10),
                          Expanded(child: _statBox('${state.targets.calories.round()}', 'kcal/day')),
                          const SizedBox(width: 10),
                          Expanded(child: _statBox('${state.streakDays}', 'day streak')),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: softCard(radius: 18),
                  child: Column(
                    children: [
                      _menuRow('🎯', 'Goals & targets', 'Weight, calories, macros'),
                      _menuRow('🥦', 'Diet preferences', 'Balanced · no restrictions'),
                      _menuRow('🔔', 'Notifications', 'Reminders & coach nudges'),
                      _menuRow('⌚', 'Connected apps', 'Apple Health, Fitbit'),
                      _menuRow('❓', 'Help & support', null, showBorder: false),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  height: 49,
                  child: OutlinedButton(
                    onPressed: () {},
                    child: Text('Log out', style: AppText.body(size: 15, weight: FontWeight.w700, color: AppColors.logoutRed)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _statBox(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Text(value, style: AppText.display(size: 17, weight: FontWeight.w800)),
          Text(label, style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.textGrey)),
        ],
      ),
    );
  }

  Widget _menuRow(String emoji, String title, String? subtitle, {bool showBorder = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: showBorder ? const Border(bottom: BorderSide(color: AppColors.cardBorder)) : null,
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 19,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(11)),
            child: Text(emoji, style: const TextStyle(fontSize: 15)),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: AppText.body(size: 15, weight: FontWeight.w700)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppText.body(size: 12, color: AppColors.textGrey)),
                ],
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.textGrey),
        ],
      ),
    );
  }
}
