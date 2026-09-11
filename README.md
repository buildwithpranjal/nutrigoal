# NutriGoal — Flutter Front-End (Assessment 4)

Implements the two major, linked features from the high-fidelity prototype:

1. **Goal Setting → Dashboard**: pick a goal (screen 03) → daily calorie/macro
   targets are calculated and drive the progress ring + macro bars on the
   Dashboard (screen 04).
2. **Log Food → Meal Plan → Meal Detail**: search/tap a food (screen 07) →
   it's added to the correct meal → the Meal Plan's running totals update
   (screen 05) → tapping an item opens its full nutrition breakdown
   (screen 06).

Both features share one `AppState` (a `ChangeNotifier`), so logging food
immediately updates the Dashboard's ring/macros as well as the Meal Plan —
this is what satisfies the "pages linked correctly" / "complex processes"
marking criteria.

Not yet implemented (left for the report's "remaining functionality"
section): Welcome/Login (01–02), Coach (09), Profile (10), and the Progress
weight chart (08) — these are static/placeholder in this build.

## Run it

1. Install Flutter (stable channel) if you haven't: https://docs.flutter.dev/get-started/install
2. From this folder:
   ```bash
   flutter pub get
   flutter run
   ```
   (Pick any connected device or emulator when prompted.)

## Push to GitHub (for your Assessment 4 report)

```bash
git init
git add .
git commit -m "NutriGoal: goal-driven dashboard + food logging"
git branch -M main
git remote add origin <your-empty-github-repo-url>
git push -u origin main
```

Then include that repo URL as the **GitHub link** in your report, and your
Figma prototype URL as the **Figma link** — the rubric checks both are
valid.

## Suggested screenshots for the report

- Goal screen with a goal selected
- Dashboard with the ring partly filled + macro bars after logging a couple of foods
- Log Food bottom sheet (meal + servings picker)
- Meal Plan with totals updated across two meals
- Meal Detail screen for the grilled chicken salad
