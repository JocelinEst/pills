import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';
import 'package:pills/themes/style.dart';
import 'package:pills/utils/view.dart';
import '../../../models/food_condition_type.dart';
import '../../../services/view.dart';
import '../../../utils/time_formatter.dart';
import '../../main_screen/widgets/view.dart';
import '../../menu_screen/widgets/menu_button_widget.dart';

class EditIntakePlanScreen extends StatefulWidget {
  final DrugInfo drug;
  final Function(TimeOfDay, double?, String?) onSave;
  final VoidCallback onDelete;

  const EditIntakePlanScreen({
    super.key,
    required this.drug,
    required this.onSave,
    required this.onDelete,
  });

  @override
  State<EditIntakePlanScreen> createState() => _EditIntakePlanScreenState();
}

class _EditIntakePlanScreenState extends State<EditIntakePlanScreen> {
  late TextEditingController _doseController;
  late TimeOfDay _selectedTime;
  String? _selectedFoodRule;
  List<FoodConditionType> _foodRules = [];
  final DrugService _service = DrugService(); // Добавлено
  bool _isDeleting = false; // Добавлено для блокировки повторных нажатий

  @override
  void initState() {
    super.initState();
    _doseController = TextEditingController(
      text: widget.drug.amount != null
          ? (widget.drug.amount! % 1 == 0
          ? widget.drug.amount!.toInt().toString()
          : widget.drug.amount!.toString())
          : '',
    );
    _selectedFoodRule = widget.drug.foodRule;
    final parts = widget.drug.intakeTime.split(':');
    _selectedTime = TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
    _loadFoodRules();
  }

  Future<void> _loadFoodRules() async {
    final rules = await DrugService().getFoodConditionTypes();
    if (mounted) {
      setState(() {
        _foodRules = rules;
      });
    }
  }

  @override
  void dispose() {
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && mounted) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _deleteIntake() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      // Сначала удаляем из базы данных
      await _service.deleteScheduledIntake(widget.drug.scheduledIntakeId!);

      // Вызываем колбэк onDelete для обновления UI в родительском виджете
      widget.onDelete();

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Прием удален')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка при удалении: $e')),
        );
      }
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MenuWidget(),
      body: Builder(
        builder: (context) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuButtonWidget(
                  iconPath: 'assets/images/menu_icon_blue.png',
                ),
                const SizedBox(height: 20),
                Text(
                  'Редактирование планового приема',
                  style: AppTextStyles.screenHeadline,
                ),
                Text(
                  widget.drug.name,
                  style: AppTextStyles.cardHeadline.copyWith(
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.drug.formType ?? '',
                  style: AppTextStyles.contentText.copyWith(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 36),
                Text(
                  'Время приема',
                  style: AppTextStyles.menuItem.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _pickTime,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.blue,
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTime(_selectedTime),
                          style: AppTextStyles.cardHeadline,
                        ),
                        const Icon(
                          Icons.access_time,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Дозировка',
                  style: AppTextStyles.menuItem.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _doseController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Введите дозировку',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Правило приема пищи',
                  style: AppTextStyles.menuItem.copyWith(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedFoodRule,
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  items: _foodRules.map((rule) {
                    return DropdownMenuItem<String>(
                      value: rule.name,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: FoodRuleHelper.getBackgroundColor(
                            rule.name,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          rule.name,
                          style: TextStyle(
                            color: FoodRuleHelper.getTextColor(
                              rule.name,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFoodRule = value;
                    });
                  },
                ),
                const SizedBox(height: 36),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final formattedTime = TimeFormatter.fromTimeOfDay(_selectedTime);
                      await DrugService().updateDrugPlan(
                        scheduledIntakeId: widget.drug.scheduledIntakeId!, // Изменено на intakeId
                        intakeTime: formattedTime,
                        dose: double.tryParse(_doseController.text) ?? 0,
                        foodRule: _selectedFoodRule,
                      );
                      if (mounted) {
                        widget.onSave(
                          _selectedTime,
                          double.tryParse(_doseController.text),
                          _selectedFoodRule,
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'Сохранить',
                      style: AppTextStyles.cardHeadline.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: _isDeleting ? null : _deleteIntake, // Исправлено
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                        width: 2,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: _isDeleting
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.red,
                      ),
                    )
                        : Text(
                      'Удалить прием',
                      style: AppTextStyles.cardHeadline.copyWith(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}