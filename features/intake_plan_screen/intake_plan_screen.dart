import 'package:flutter/material.dart';
import 'package:pills/services/view.dart';
import '../../themes/style.dart';
import '../button_widgets/view.dart';
import '../menu_screen/menu_widget.dart';
import '../menu_screen/widgets/view.dart';
import 'widgets/view.dart';
import 'package:pills/models/view.dart';

class IntakePlansScreen extends StatefulWidget {
  const IntakePlansScreen({super.key});

  @override
  State<IntakePlansScreen> createState() => _IntakePlansScreenState();
}

class _IntakePlansScreenState extends State<IntakePlansScreen> {
  final IntakePlanService _intakePlanService = IntakePlanService();

  List<IntakePlanFull> _plans = [];
  bool _loading = true;

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await _intakePlanService.getIntakePlansFull();
    setState(() {
      _plans = data;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      drawer: const MenuWidget(),
      body: SafeArea(
        child: Column(
          children: [
            const MenuButtonWidget(iconPath: 'assets/images/menu_icon.png'),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   Text(
                    "Системы приема",
                    style: AppTextStyles.screenHeadline.copyWith(color: Colors.white),
                  ),

                  AddButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/createIntakePlan')
                          .then((_) => _load());
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: _plans.map(
                      (plan) => PlanCard(
                    plan: plan,
                    formatDate: formatDate,
                  ),
                ).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}