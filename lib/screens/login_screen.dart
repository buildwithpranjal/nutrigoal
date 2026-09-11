import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/pill_button.dart';
import 'goal_screen.dart';

/// Pixel-matched to the Figma CSS export for screen 02 (Login).
/// Not wired to real authentication (out of scope for this
/// assessment); "Log in" simply continues to goal selection.
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ListView(
            children: [
              const SizedBox(height: 8),
              const PillBackButton(),
              const SizedBox(height: 18),
              Text('Welcome back', style: AppText.display(size: 26, weight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text('Log in to continue your plan.', style: AppText.body(size: 15, color: AppColors.textGrey)),
              const SizedBox(height: 24),
              Text('Email', style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.labelDark)),
              const SizedBox(height: 7),
              const TextField(decoration: InputDecoration(hintText: 'you@email.com')),
              const SizedBox(height: 16),
              Text('Password', style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.labelDark)),
              const SizedBox(height: 7),
              const TextField(obscureText: true, decoration: InputDecoration(hintText: '••••••••')),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(0, 0)),
                  onPressed: () {},
                  child: Text('Forgot password?',
                      style: AppText.body(size: 13, weight: FontWeight.w700, color: AppColors.primaryGreen)),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const GoalScreen()),
                  ),
                  child: const Text('Log in'),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.controlBorder, height: 1)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or', style: AppText.body(size: 12, color: AppColors.textGrey)),
                  ),
                  const Expanded(child: Divider(color: AppColors.controlBorder, height: 1)),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 49,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('🔵', style: TextStyle(fontSize: 17)),
                      const SizedBox(width: 9),
                      Text('Continue with Google', style: AppText.body(size: 15, weight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 49,
                child: OutlinedButton(
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.apple, size: 17, color: AppColors.textDark),
                      const SizedBox(width: 9),
                      Text('Continue with Apple', style: AppText.body(size: 15, weight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Center(
                child: Wrap(
                  children: [
                    Text("Don't have an account? ", style: AppText.body(size: 14, color: AppColors.textGrey)),
                    Text('Sign up', style: AppText.body(size: 14, weight: FontWeight.w700, color: AppColors.primaryGreen)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
