import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';
import 'package:pills/themes/style.dart';

class FilterWidget extends StatefulWidget {
  final List<DrugInfo> allDrugs;
  final Function(List<DrugInfo>) onFilterChanged;

  const FilterWidget({
    super.key,
    required this.allDrugs,
    required this.onFilterChanged,
  });

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  final TextEditingController _doseMinController = TextEditingController();
  final TextEditingController _doseMaxController = TextEditingController();
  final TextEditingController _dateStartController = TextEditingController();
  final TextEditingController _dateEndController = TextEditingController();

  String? _selectedDrugName;
  String? _selectedDrugType;
  String? _selectedFoodRule;


  List<String> get _drugNames {
    return widget.allDrugs.map((drug) => drug.name).toSet().toList();
  }

  List<String> get _drugTypes {
    return widget.allDrugs
        .where((drug) => drug.formType != null && drug.formType!.isNotEmpty)
        .map((drug) => drug.formType!)
        .toSet()
        .toList();
  }

  List<String> get _foodRules {
    return widget.allDrugs
        .where((drug) => drug.foodRule != null && drug.foodRule!.isNotEmpty)
        .map((drug) => drug.foodRule!)
        .toSet()
        .toList();
  }

  @override
  void dispose() {
    _doseMinController.dispose();
    _doseMaxController.dispose();
    _dateStartController.dispose();
    _dateEndController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Фильтр',
                  style:AppTextStyles.headline,
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Названия препаратов
                  Text(
                    'Название препарата',
                    style: AppTextStyles.contentText,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    value: _selectedDrugName,
                    hint: const Text('Выберите препарат'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Все'),
                      ),
                      ..._drugNames.map(
                            (name) => DropdownMenuItem(
                          value: name,
                          child: Text(name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedDrugName = value);
                      _applyFilter();
                    },
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Тип препарата',
                    style: AppTextStyles.contentText,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    value: _selectedDrugType,
                    hint: const Text('Выберите тип'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Все'),
                      ),
                      ..._drugTypes.map(
                            (type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedDrugType = value);
                      _applyFilter();
                    },
                  ),
                  const SizedBox(height: 20),

                  // Правила еды
                  Text(
                    'Правило приема',
                    style: AppTextStyles.contentText,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    value: _selectedFoodRule,
                    hint: const Text('Выберите правило'),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Все'),
                      ),
                      ..._foodRules.map(
                            (rule) => DropdownMenuItem(
                          value: rule,
                          child: Text(rule),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedFoodRule = value);
                      _applyFilter();
                    },
                  ),
                  const SizedBox(height: 20),

                  // Диапазон дозы
                  Text(
                    'Дозировка',
                      style: AppTextStyles.contentText,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _doseMinController,
                          decoration: InputDecoration(
                            hintText: 'От',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _applyFilter(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _doseMaxController,
                          decoration: InputDecoration(
                            hintText: 'До',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onChanged: (_) => _applyFilter(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Диапазон дат
                  Text(
                    'Дата приема',
                    style: AppTextStyles.contentText,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dateStartController,
                          decoration: InputDecoration(
                            hintText: 'Начальная дата',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              _dateStartController.text =
                              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                              _applyFilter();
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: _dateEndController,
                          decoration: InputDecoration(
                            hintText: 'Конечная дата',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                          onTap: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              _dateEndController.text =
                              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
                              _applyFilter();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey, width: 0.5),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clearFilters,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Сбросить'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF276DCF),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Применить',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _applyFilter() {
    List<DrugInfo> filtered = List.from(widget.allDrugs);

    if (_selectedDrugName != null && _selectedDrugName!.isNotEmpty) {
      filtered = filtered.where((drug) => drug.name == _selectedDrugName).toList();
    }

    if (_selectedDrugType != null && _selectedDrugType!.isNotEmpty) {
      filtered = filtered.where((drug) => drug.formType == _selectedDrugType).toList();
    }

    if (_selectedFoodRule != null && _selectedFoodRule!.isNotEmpty) {
      filtered = filtered.where((drug) => drug.foodRule == _selectedFoodRule).toList();
    }

    if (_doseMinController.text.isNotEmpty) {
      final minDose = double.tryParse(_doseMinController.text);

      if (minDose != null) {
        filtered = filtered.where((drug) {
          final dose = drug.amount ?? 0;
          return dose >= minDose;
        }).toList();
      }
    }

    if (_doseMaxController.text.isNotEmpty) {
      final maxDose = double.tryParse(_doseMaxController.text);
      if (maxDose != null) {
        filtered = filtered.where((drug) {
          final dose = drug.amount ?? 0;
          return dose <= maxDose;
        }).toList();
      }
    }

    if (_dateStartController.text.isNotEmpty) {
      final startDate = DateTime.tryParse(_dateStartController.text);
      if (startDate != null) {
        filtered = filtered.where((drug) => drug.date.isAfter(startDate.subtract(const Duration(days: 1)))).toList();
      }
    }

    if (_dateEndController.text.isNotEmpty) {
      final endDate = DateTime.tryParse(_dateEndController.text);
      if (endDate != null) {
        filtered = filtered.where((drug) => drug.date.isBefore(endDate.add(const Duration(days: 1)))).toList();
      }
    }

    widget.onFilterChanged(filtered);
  }

  void _clearFilters() {
    setState(() {
      _selectedDrugName = null;
      _selectedDrugType = null;
      _selectedFoodRule = null;
      _doseMinController.clear();
      _doseMaxController.clear();
      _dateStartController.clear();
      _dateEndController.clear();
    });
    _applyFilter();
  }
}