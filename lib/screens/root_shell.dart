import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'coach_screen.dart';
import 'dashboard_screen.dart';
import 'log_food_screen.dart';
import 'meal_plan_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';

/// Hosts the five bottom-nav destinations. Home, Plan, and Log are fully
/// implemented (Features 1 & 2); Progress and Profile/Coach have a
/// matching visual design but are not wired to real history/auth.
class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  int _index = 0;

  void goToTab(int i) => setState(() => _index = i);

  static const _items = [
    (icon: Icons.home_outlined, label: 'Home'),
    (icon: Icons.receipt_long_outlined, label: 'Plan'),
    (icon: Icons.add_circle_outline, label: 'Log'),
    (icon: Icons.show_chart, label: 'Progress'),
    (icon: Icons.person_outline, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardScreen(onViewMealPlan: () => goToTab(1)),
      const MealPlanScreen(),
      LogFoodScreen(onFoodLogged: () => goToTab(1)),
      const ProgressScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 22),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.controlBorder)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < _items.length; i++)
              GestureDetector(
                onTap: () => goToTab(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_items[i].icon, size: 24, color: i == _index ? AppColors.primaryGreen : AppColors.textGrey),
                    const SizedBox(height: 5),
                    Text(
                      _items[i].label,
                      style: AppText.body(
                        size: 10,
                        weight: i == _index ? FontWeight.w700 : FontWeight.w600,
                        color: i == _index ? AppColors.primaryGreen : AppColors.textGrey,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
