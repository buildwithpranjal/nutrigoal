import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/food_catalog.dart';
import '../models/models.dart';
import '../state/app_state.dart';
import '../theme/app_theme.dart';

enum _Filter { common, myMeals, recent }

/// Pixel-matched to the Figma CSS export for screen 07 (Log Food).
/// The Scan/My meals/Recent row are quick filters (Scan has no camera
/// in this build and shows a note instead); "Common foods" is the
/// default section header, not a fourth tab.
class LogFoodScreen extends StatefulWidget {
  final VoidCallback onFoodLogged;
  const LogFoodScreen({super.key, required this.onFoodLogged});

  @override
  State<LogFoodScreen> createState() => _LogFoodScreenState();
}

class _LogFoodScreenState extends State<LogFoodScreen> {
  String _query = '';
  _Filter _filter = _Filter.common;

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, state, _) {
        List<FoodItem> source;
        String header;
        switch (_filter) {
          case _Filter.common:
            source = commonFoods;
            header = 'Common foods';
            break;
          case _Filter.myMeals:
            source = state.customFoods;
            header = 'My foods';
            break;
          case _Filter.recent:
            final seen = <String>{};
            source = [for (final e in state.entries.reversed) if (seen.add(e.food.id)) e.food];
            header = 'Recent';
            break;
        }
        final filtered = source.where((f) => f.name.toLowerCase().contains(_query.toLowerCase())).toList();

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(22, 4, 22, 20),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Log food', style: AppText.display(size: 24, weight: FontWeight.w800)),
                ),
                Container(
                  height: 45,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: AppColors.controlBorder),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, size: 18, color: AppColors.textGrey),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            hintText: 'Search foods, e.g. banana',
                            hintStyle: AppText.body(size: 15, color: AppColors.textGrey),
                          ),
                          onChanged: (v) => setState(() => _query = v),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(child: _quickPill('📷', 'Scan', _Filter.common, isScan: true)),
                    const SizedBox(width: 8),
                    Expanded(child: _quickPill('🍽️', 'My meals', _Filter.myMeals)),
                    const SizedBox(width: 8),
                    Expanded(child: _quickPill('⭐', 'Recent', _Filter.recent)),
                  ],
                ),
                const SizedBox(height: 18),
                Text(header, style: AppText.display(size: 18, weight: FontWeight.w800)),
                const SizedBox(height: 8),
                if (_filter == _Filter.myMeals)
                  _AddCustomFoodRow(onTap: () => _openCustomFoodForm(context)),
                if (filtered.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      _filter == _Filter.myMeals ? 'No custom foods yet.' : 'No foods found.',
                      style: AppText.body(size: 13, color: AppColors.textGrey),
                    ),
                  )
                else
                  ...filtered.map((food) => _FoodRow(
                        food: food,
                        onAdd: () => _openAddSheet(context, food),
                      )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _quickPill(String emoji, String label, _Filter filter, {bool isScan = false}) {
    return GestureDetector(
      onTap: () {
        if (isScan) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camera scanning is not available in this build.')),
          );
          return;
        }
        setState(() => _filter = filter);
      },
      child: Container(
        height: 38,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: !isScan && _filter == filter ? AppColors.primaryGreen : AppColors.controlBorder),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(label, style: AppText.body(size: 13, weight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _openAddSheet(BuildContext context, FoodItem food) {
    MealType meal = MealType.breakfast;
    double servings = 1;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: AppText.body(size: 18, weight: FontWeight.w700)),
                  Text('${food.caloriesPerServing.round()} kcal per ${food.servingLabel}',
                      style: AppText.body(color: AppColors.textGrey)),
                  const SizedBox(height: 16),
                  Text('Add to', style: AppText.body(weight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: MealType.values.map((m) {
                      final selected = meal == m;
                      return ChoiceChip(
                        label: Text(m.label),
                        selected: selected,
                        onSelected: (_) => setSheetState(() => meal = m),
                        selectedColor: AppColors.primaryGreen.withOpacity(0.2),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Servings', style: AppText.body(weight: FontWeight.w600)),
                      const Spacer(),
                      IconButton(
                        onPressed: servings > 0.5 ? () => setSheetState(() => servings -= 0.5) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(servings.toString(), style: const TextStyle(fontSize: 16)),
                      IconButton(
                        onPressed: () => setSheetState(() => servings += 0.5),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AppState>().logFood(food, meal, servings);
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${food.name} to ${meal.label}')),
                      );
                      widget.onFoodLogged();
                    },
                    child: const Text('Log this food'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _openCustomFoodForm(BuildContext context) {
    final nameCtrl = TextEditingController();
    final servingCtrl = TextEditingController(text: '1 serving');
    final calCtrl = TextEditingController();
    final proteinCtrl = TextEditingController();
    final carbsCtrl = TextEditingController();
    final fatCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
          ),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Add your own food', style: AppText.body(size: 18, weight: FontWeight.w700)),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Food name'),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: servingCtrl,
                    decoration: const InputDecoration(labelText: 'Serving label (e.g. 1 cup)'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: calCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Calories (kcal)'),
                          validator: (v) => double.tryParse(v ?? '') == null ? 'Number' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: proteinCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Protein (g)'),
                          validator: (v) => double.tryParse(v ?? '') == null ? 'Number' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: carbsCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Carbs (g)'),
                          validator: (v) => double.tryParse(v ?? '') == null ? 'Number' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: fatCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Fat (g)'),
                          validator: (v) => double.tryParse(v ?? '') == null ? 'Number' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;
                      context.read<AppState>().addCustomFood(
                            name: nameCtrl.text.trim(),
                            servingLabel: servingCtrl.text.trim(),
                            calories: double.parse(calCtrl.text),
                            protein: double.parse(proteinCtrl.text),
                            carbs: double.parse(carbsCtrl.text),
                            fat: double.parse(fatCtrl.text),
                          );
                      Navigator.of(sheetContext).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${nameCtrl.text.trim()} added to My foods')),
                      );
                    },
                    child: const Text('Save food'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddCustomFoodRow extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCustomFoodRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 22,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.cardTint, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, size: 16, color: AppColors.primaryGreen),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text('Add your own food',
                  style: AppText.body(size: 15, weight: FontWeight.w700, color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }
}

class _FoodRow extends StatelessWidget {
  final FoodItem food;
  final VoidCallback onAdd;
  const _FoodRow({required this.food, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    final emoji = commonFoodEmoji[food.id];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 11),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: AppColors.cardBorder))),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 22,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: AppColors.trackGrey, borderRadius: BorderRadius.circular(12)),
            child: emoji != null
                ? Text(emoji, style: const TextStyle(fontSize: 16))
                : const Icon(Icons.edit_note, size: 16, color: AppColors.textDark),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(food.name, style: AppText.body(size: 15, weight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text('${food.servingLabel} · ${food.caloriesPerServing.round()} kcal',
                    style: AppText.body(size: 12.5, color: AppColors.textGrey)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              width: 40,
              height: 20,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
