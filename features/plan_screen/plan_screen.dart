import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pills/features/plan_screen/widgets/edit_plan.dart';
import 'package:pills/utils/view.dart';
import 'package:pills/models/view.dart';
import 'package:pills/services/view.dart';
import 'package:pills/features/plan_screen/widgets/view.dart';
import 'package:pills/features/main_screen/widgets/view.dart';
import '../../utils/time_formatter.dart';
import '../menu_screen/widgets/view.dart';

class PlanWidget extends StatefulWidget {
  final VoidCallback? onRefresh;
  final VoidCallback? onDrugStatusChanged;

  const PlanWidget({
    super.key,
    this.onRefresh,
    this.onDrugStatusChanged,
  });

  @override
  State<PlanWidget> createState() => _PlanWidgetState();
}

class _PlanWidgetState extends State<PlanWidget> {
  final DrugService _service = DrugService();
  Map<DateTime, List<DrugInfo>> _groupedDrugs = {};
  List<DrugInfo> _allDrugs = [];
  List<DrugInfo> _currentDisplayedDrugs = [];
  bool _isLoading = true;
  bool _isFiltered = false;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _loadAllDrugs();
  }

  Future<void> _loadAllDrugs() async {
    try {
      final allDrugs = await _service.getAllDrugs();
      _allDrugs = allDrugs;
      _currentDisplayedDrugs = List.from(allDrugs);
      _groupDrugs(_currentDisplayedDrugs);
      if (mounted) setState(() => _isLoading = false);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _updateDrugStatus(DrugInfo drug, bool newStatus) async {
    if (drug.scheduledIntakeId == null) return;

    await _service.updateDrugStatusById(drug.scheduledIntakeId!, newStatus);

    final allIndex = _allDrugs.indexWhere((d) => d.scheduledIntakeId == drug.scheduledIntakeId);
    if (allIndex != -1) _allDrugs[allIndex].isTaken = newStatus;

    final displayIndex = _currentDisplayedDrugs.indexWhere((d) => d.scheduledIntakeId == drug.scheduledIntakeId);
    if (displayIndex != -1) _currentDisplayedDrugs[displayIndex].isTaken = newStatus;

    _groupDrugs(_currentDisplayedDrugs);
    setState(() => drug.isTaken = newStatus);
    widget.onRefresh?.call();
  }

  void _groupDrugs(List<DrugInfo> drugs) {
    final Map<DateTime, List<DrugInfo>> grouped = {};
    for (var drug in drugs) {
      final date = DateTime(drug.date.year, drug.date.month, drug.date.day);
      grouped.putIfAbsent(date, () => []).add(drug);
    }
    _groupedDrugs = Map.fromEntries(grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)));
  }

  void _openFilter() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterWidget(
        allDrugs: _allDrugs,
        onFilterChanged: (filteredDrugs) {
          _currentDisplayedDrugs = List.from(filteredDrugs);
          _groupDrugs(_currentDisplayedDrugs);
          setState(() => _isFiltered = true);
        },
      ),
    );
  }

  void _clearFilter() {
    _currentDisplayedDrugs = List.from(_allDrugs);
    _groupDrugs(_currentDisplayedDrugs);
    setState(() => _isFiltered = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildBackgroundCircles(),
          _buildMainContent(),
          if (_isUpdating)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
      drawer: const MenuWidget(),
    );
  }

  Widget _buildBackgroundCircles() {
    return Positioned(
      right: -70,
      top: -60,
      child: Container(
        width: 250,
        height: 250,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color.fromRGBO(180, 211, 255, 0.2), width: 25),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Builder(
      builder: (context) => Column(
        children: [
          const SizedBox(height: 60),
          MenuButtonWidget(iconPath: 'assets/images/menu_icon_blue.png'),
          _buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _groupedDrugs.isEmpty
                ? const Center(child: Text('Нет запланированных приемов', style: TextStyle(fontSize: 16, color: Colors.grey)))
                : _buildDrugList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 26, right: 26, bottom: 16, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'План',
            style: GoogleFonts.montserratAlternates(fontSize: 35, fontWeight: FontWeight.w900),
          ),
          Row(
            children: [
              if (_isFiltered)
                IconButton(onPressed: _clearFilter, icon: const Icon(Icons.clear), color: Colors.blue),
              IconButton(onPressed: _openFilter, icon: const Icon(Icons.filter_list), color: Colors.blue, iconSize: 30),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrugList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _groupedDrugs.length,
      itemBuilder: (context, index) {
        final date = _groupedDrugs.keys.elementAt(index);
        final drugs = _groupedDrugs[date]!;
        final isLastDate = index == _groupedDrugs.length - 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 8),
              child: Text(
                DateFormatter.formatDate(date),
                style: GoogleFonts.montserratAlternates(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            ...drugs.map((drug) {
              return PlanDrugCard(
                drug: drug,
                onStatusToggle: () => _updateDrugStatus(drug, !drug.isTaken),
                onEdit: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditIntakePlanScreen(
                        drug: drug,
                        onSave: (TimeOfDay time, double? dose, String? foodRule) async {
                          if (mounted) {
                            setState(() => _isUpdating = true);
                          }
                          try {
                            await _service.updateDrugPlan(
                              scheduledIntakeId: drug.scheduledIntakeId!,
                              intakeTime: TimeFormatter.fromTimeOfDay(time),
                              dose: dose ?? 0,
                              foodRule: foodRule,
                            );

                            final updatedDrug = drug.copyWith(
                              intakeTime: TimeFormatter.fromTimeOfDay(time),
                              amount: dose,
                              foodRule: foodRule,
                            );

                            final allIndex = _allDrugs.indexWhere(
                                  (d) => d.scheduledIntakeId == drug.scheduledIntakeId,
                            );
                            if (allIndex != -1) {
                              _allDrugs[allIndex] = updatedDrug;
                            }

                            final displayIndex = _currentDisplayedDrugs.indexWhere(
                                  (d) => d.scheduledIntakeId == drug.scheduledIntakeId,
                            );
                            if (displayIndex != -1) {
                              _currentDisplayedDrugs[displayIndex] = updatedDrug;
                            }

                            _groupDrugs(_currentDisplayedDrugs);

                            if (mounted) {
                              setState(() => _isUpdating = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('План приема обновлен')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isUpdating = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ошибка: $e')),
                              );
                            }
                          }
                        },
                        onDelete: () async {
                          if (mounted) {
                            setState(() => _isUpdating = true);
                          }
                          try {
                            await _service.deleteScheduledIntake(drug.scheduledIntakeId!);
                            if (mounted) {
                              setState(() {
                                _allDrugs.removeWhere(
                                      (d) => d.scheduledIntakeId == drug.scheduledIntakeId,
                                );
                                _currentDisplayedDrugs.removeWhere(
                                      (d) => d.scheduledIntakeId == drug.scheduledIntakeId,
                                );
                                _groupDrugs(_currentDisplayedDrugs);
                                _isUpdating = false;
                              });
                            }
                            if (mounted) {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Прием удален')),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              setState(() => _isUpdating = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Ошибка при удалении: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            if (!isLastDate)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Divider(
                  color: Colors.blue.shade300,
                  thickness: 1,
                ),
              ),
          ],
        );
      },
    );
  }
}