import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'root_shell.dart';

/// Pixel-matched to the Figma CSS export for screen 03 (Goal Wizard).
class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  GoalType? _picked = GoalType.loseWeight;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  const PillBackButton(),
                  const SizedBox(width: 12),
                  Text('Step 1 of 5', style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.textGrey)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                height: 8,
                decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(99)),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: 70 / 342,
                  child: Container(
                    decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(99)),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Text("What's your main goal?", style: AppText.display(size: 26, weight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text("We'll tailor your daily targets around this.",
                  style: AppText.body(size: 15, color: AppColors.textGrey, height: 1.4)),
              const SizedBox(height: 20),
              for (final goal in GoalType.values) ...[
                _GoalOption(
                  goal: goal,
                  selected: _picked == goal,
                  onTap: () => setState(() => _picked = goal),
                ),
                const SizedBox(height: 11),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _picked == null
                      ? null
                      : () {
                          context.read<AppState>().selectGoal(_picked!);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const RootShell()),
                          );
                        },
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  final GoalType goal;
  final bool selected;
  final VoidCallback onTap;

  const _GoalOption({required this.goal, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.cardTint : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primaryGreen : AppColors.controlBorder,
            width: selected ? 2 : 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? Colors.white : AppColors.trackGrey,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(goal.emoji, style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(goal.label, style: AppText.body(size: 15, weight: FontWeight.w700)),
                  const SizedBox(height: 2),
                  Text(goal.description, style: AppText.body(size: 12.5, color: AppColors.textGrey)),
                ],
              ),
            ),
            Container(
              width: 22,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? AppColors.primaryGreen : Colors.white,
                border: Border.all(color: selected ? AppColors.primaryGreen : AppColors.controlBorder, width: 2),
              ),
              child: selected
                  ? Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
