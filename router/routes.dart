import 'package:flutter/material.dart';
import 'package:pills/features/main_screen/main_screen.dart';
import 'package:pills/features/drug_screen/drug_screen.dart';
import 'package:pills/features/plan_screen/plan_screen.dart';
import 'package:pills/features/intake_plan_screen/intake_plan_screen.dart';
import '../features/add_intake_plan_screen/view.dart';
import '../features/drug_screen/widgets/view.dart';
import '../models/view.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => const MainScreen(title: 'Happy Pills'),
  '/drugs': (context) => const DrugWidget(),
  '/plan': (context) => const PlanWidget(),
  '/intakePlans': (context) => const IntakePlansScreen(),
  '/createIntakePlan': (context) => const CreateIntakePlanScreen(),
  '/addDrug': (context) => const AddDrugWidget(),
};

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(
          builder: (_) => const MainScreen(title: 'Happy Pills')
      );

    case '/drugs':
      return MaterialPageRoute(builder: (_) => const DrugWidget());
    case '/plan':
      return MaterialPageRoute(builder: (_) => const PlanWidget());
    case '/intakePlans':
      return MaterialPageRoute(builder: (_) => const IntakePlansScreen());
    case  '/createIntakePlan':
      return MaterialPageRoute(builder: (_) => const CreateIntakePlanScreen());
    case '/addDrug':
      return MaterialPageRoute(builder: (_) => const AddDrugWidget());
    case '/editDrug':
      final drug = settings.arguments as DrugInfo;
      return MaterialPageRoute<bool>(
        builder: (context) => EditDrugWidget(drug: drug),
        settings: settings,
      );
  }
  return null;
}