import 'package:flutter/material.dart';
import 'package:pills/features/main_screen/widgets/view.dart';
import 'package:pills/models/view.dart';
import 'package:pills/features/add_intake_plan_screen/widgets/view.dart';
import '../../services/drug_service.dart';
import '../../services/intake_plan_creation_service.dart';
import '../../services/intake_plan_service.dart';
import '../../utils/view.dart';
import '../menu_screen/widgets/menu_button_widget.dart';
import 'widgets/current_step_builder.dart';

class CreateIntakePlanScreen extends StatefulWidget {
  const CreateIntakePlanScreen({super.key});
  @override
  State<CreateIntakePlanScreen> createState() => _CreateIntakePlanScreenState();
}

class _CreateIntakePlanScreenState extends State<CreateIntakePlanScreen> {
  final DrugService drugService = DrugService();
  final IntakePlanService intakePlanService = IntakePlanService();
   int _intervalDays = 1;
  final List<int> _selectedWeekDays = [];
  final List<IntakeTimeWithDose> _intakeTimes = [];
  late final IntakePlanCreationService _createPlanService;
  List<Map<String, dynamic>> _drugs = [];
  Map<String, dynamic>? _selectedDrug;
  List<String> _foodConditions = [];
  String? _intakeType;
  DateTime? _startDate;
  DateTime? _endDate;
  String? _schedulePattern;
  int _currentStep = 0;

  Future<void> _loadFoodConditions() async {
    final data = await _createPlanService.getAllFoodConditions();

    setState(() {
      _foodConditions = data
          .map((e) => e['Name'] as String)
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();

    _createPlanService = IntakePlanCreationService(intakePlanService);

    _loadDrugs();
    _loadFoodConditions();
  }
  bool get canProceed {
    return IntakePlanValidator.canProceed(
      currentStep: _currentStep,
      selectedDrug: _selectedDrug,
      intakeType: _intakeType,
      startDate: _startDate,
      intakeTimes: _intakeTimes,
      schedulePattern: _schedulePattern,
      intervalDays: _intervalDays,
      selectedWeekDays: _selectedWeekDays,
    );
  }
  Future<void> _loadDrugs() async {
    final drugs = await drugService.getAllDrugsList();
    setState(() {
      _drugs = drugs;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(),
      body: SafeArea(
        child: Column(
          children: [
            MenuButtonWidget(
              iconPath: 'assets/images/menu_icon.png',
            ),

            StepIndicator(
              currentStep: _currentStep,
              intakeType: _intakeType,
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: CurrentStepBuilder(
                  onPatternSelected: (value) {
                    setState(() {
                      _schedulePattern = value;
                    });
                  },

                  onIntervalChanged: (value) {
                    setState(() {
                      _intervalDays = value;
                    });
                  },

                  onWeekDayToggled: (day) {
                    setState(() {
                      if (_selectedWeekDays.contains(day)) {
                        _selectedWeekDays.remove(day);
                      } else {
                        _selectedWeekDays.add(day);
                      }
                    });
                  },
                  onUpdateFoodCondition: (index, value) {
                    setState(() {
                      final old = _intakeTimes[index];

                      _intakeTimes[index] = IntakeTimeWithDose(
                        time: old.time,
                        doseAmount: old.doseAmount,
                        foodCondition: value,
                      );
                    });
                  },
                  onAddIntakeTime: () async {
                    final pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (pickedTime == null) return;

                    final isDuplicate = _intakeTimes.any((t) =>
                    t.time.hour == pickedTime.hour &&
                        t.time.minute == pickedTime.minute);

                    if (isDuplicate) {
                      if (!mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Такое время уже добавлено'),
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _intakeTimes.add(
                        IntakeTimeWithDose(
                          time: pickedTime,
                          doseAmount: '',
                        ),
                      );
                    });
                  },
                  currentStep: _currentStep,
                  intakeType: _intakeType,
                  drugs: _drugs,
                  selectedDrug: _selectedDrug,
                  intakeTimes: _intakeTimes,
                  schedulePattern: _schedulePattern,
                  intervalDays: _intervalDays,
                  selectedWeekDays: _selectedWeekDays,
                  startDate: _startDate,
                  endDate: _endDate,
                  foodConditions: _foodConditions,
                  onDrugSelected: (drug) {
                    setState(() {
                      _selectedDrug = drug;
                      _intakeTimes.clear();
                    });
                  },
                  onAddNewDrug: () {},
                  onTypeSelected: (type) =>
                      setState(() => _intakeType = type),
                  onStartDateSelected: (d) =>
                      setState(() => _startDate = d),
                  onEndDateSelected: (d) =>
                      setState(() => _endDate = d),
                  onRemoveIntakeTime: (i) =>
                      setState(() => _intakeTimes.removeAt(i)),
                  onUpdateTime: (i, t) =>
                      setState(() => _intakeTimes[i].time = t),
                  onUpdateDose: (i, d) =>
                      setState(() => _intakeTimes[i].doseAmount = d),
                ),
              ),
            ),

            NavigationButtons(
              currentStep: _currentStep,
              totalSteps: _intakeType == 'single' ? 4 : 6,
              canProceed: canProceed,
              onBack: () {
                setState(() => _currentStep--);
              },
              onNext: _goToNextStep,
            ),
          ],
        ),
      ),
    );
  }
  void _goToNextStep() {
    int totalSteps = _intakeType == 'single' ? 4 : 6;
    if (_currentStep == totalSteps - 1) {
      _save();
    } else {
      setState(() => _currentStep++);
    }
  }
  Future<void> _save() async {
    if (_selectedDrug == null) return;
    if (_intakeType == 'single' && _startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Пожалуйста, выберите дату приема')),
      );
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await _createPlanService.createPlan(
        selectedDrug: _selectedDrug!,
        intakeType: _intakeType,
        startDate: _startDate!,
        endDate: _endDate,
        intakeTimes: _intakeTimes,
        schedulePattern: _schedulePattern,
        intervalDays: _intervalDays,
        selectedWeekDays: _selectedWeekDays,
      );
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('План приема успешно создан!')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    }
  }
}