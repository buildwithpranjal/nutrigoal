import '../models/models.dart';

/// Common foods shown on the Log Food screen, matching the exact
/// Figma export (screen 07): names, servings, and calories are taken
/// directly from that spec.
final List<FoodItem> commonFoods = [
  const FoodItem(
    id: 'banana',
    name: 'Banana',
    servingLabel: '1 medium',
    caloriesPerServing: 105,
    proteinG: 1.3,
    carbsG: 27,
    fatG: 0.4,
  ),
  const FoodItem(
    id: 'boiled_eggs',
    name: 'Boiled eggs',
    servingLabel: '2 large',
    caloriesPerServing: 156,
    proteinG: 13,
    carbsG: 1.1,
    fatG: 11,
  ),
  const FoodItem(
    id: 'chicken_breast',
    name: 'Chicken breast',
    servingLabel: '150g',
    caloriesPerServing: 248,
    proteinG: 46,
    carbsG: 0,
    fatG: 5.4,
  ),
  const FoodItem(
    id: 'brown_rice',
    name: 'Brown rice',
    servingLabel: '1 cup',
    caloriesPerServing: 216,
    proteinG: 5,
    carbsG: 45,
    fatG: 1.8,
  ),
  const FoodItem(
    id: 'skim_milk',
    name: 'Skim milk',
    servingLabel: '250ml',
    caloriesPerServing: 83,
    proteinG: 8.3,
    carbsG: 12,
    fatG: 0.2,
  ),
  const FoodItem(
    id: 'avocado',
    name: 'Avocado',
    servingLabel: '½',
    caloriesPerServing: 160,
    proteinG: 2,
    carbsG: 8.5,
    fatG: 14.7,
  ),
];

/// Emoji glyphs for the common-foods list, matching the exact export.
const Map<String, String> commonFoodEmoji = {
  'banana': '🍌',
  'boiled_eggs': '🥚',
  'chicken_breast': '🍗',
  'brown_rice': '🍚',
  'skim_milk': '🥛',
  'avocado': '🥑',
};

/// The composite "meal" featured on the Meal Plan screen and its detail view.
final FoodItem grilledChickenSalad = const FoodItem(
  id: 'grilled_chicken_salad',
  name: 'Grilled chicken salad',
  servingLabel: '1 bowl',
  caloriesPerServing: 560,
  proteinG: 45,
  carbsG: 30,
  fatG: 22,
  ingredients: [
    '200g grilled chicken breast',
    'Mixed greens & spinach',
    'Cherry tomatoes, cucumber',
    '1 tbsp olive oil dressing',
    'Handful of walnuts',
  ],
);

/// Suggested meal-plan items shown for each meal slot, matching the
/// exact Figma export (screen 05).
final FoodItem oatsAndBerries = const FoodItem(
  id: 'oats_berries',
  name: 'Oats & mixed berries',
  servingLabel: '1 bowl',
  caloriesPerServing: 420,
  proteinG: 22,
  carbsG: 58,
  fatG: 9,
);

final FoodItem salmonQuinoaBowl = const FoodItem(
  id: 'salmon_quinoa',
  name: 'Salmon & quinoa bowl',
  servingLabel: '1 bowl',
  caloriesPerServing: 520,
  proteinG: 38,
  carbsG: 40,
  fatG: 20,
);

final FoodItem greekYoghurtAlmonds = const FoodItem(
  id: 'yoghurt_almonds',
  name: 'Greek yogurt & almonds',
  servingLabel: '1 cup',
  caloriesPerServing: 180,
  proteinG: 15,
  carbsG: 11,
  fatG: 9,
);

/// Maps each meal slot to its suggested/default item, used to fill the
/// Meal Plan screen before the user has logged anything for that meal.
final Map<MealType, FoodItem> suggestedMeal = {
  MealType.breakfast: oatsAndBerries,
  MealType.lunch: grilledChickenSalad,
  MealType.dinner: salmonQuinoaBowl,
  MealType.snack: greekYoghurtAlmonds,
};
