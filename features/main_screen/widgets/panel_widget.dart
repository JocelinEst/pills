import 'package:flutter/material.dart';
import 'package:pills/utils/data_formatter.dart';
import '../../../services/drug_service.dart';
import 'package:pills/models/view.dart';
import '../../../themes/style.dart';
import '../../../utils/view.dart';

class PanelOfTheDay extends StatefulWidget {
  final VoidCallback? onDrugStatusChanged;
  final DateTime? selectedDate;

  const PanelOfTheDay({
    super.key, this.onDrugStatusChanged,
    this.selectedDate,
  });

  @override
  State<PanelOfTheDay> createState() => _PanelOfTheDayState();
}

class _PanelOfTheDayState extends State<PanelOfTheDay> {
  final DrugService _service = DrugService();

  List<DrugInfo> _todayDrugs = [];
  bool _isLoading = true;
  final Map<int, bool> _processingStatus = {};


  @override
  void didUpdateWidget(covariant PanelOfTheDay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedDate != widget.selectedDate) {
      setState(() {
        _isLoading = true;
      });
      _loadTodayDrugs();
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTodayDrugs();
  }

  Future<void> _loadTodayDrugs() async {
    try {
      final date = widget.selectedDate ?? DateTime.now();
      final result = await _service.getDrugsForDatePanel(date);

      if (!mounted) return;

      setState(() {
        _todayDrugs = result;
        _isLoading = false;
      });
    } catch (e) {
      print('=== ОШИБКА: $e ===');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
  Future<void> _toggleDrugStatus(DrugInfo drug) async {
    final intakeId = drug.scheduledIntakeId;
    if (intakeId == null) return;
    if (_processingStatus[intakeId] == true) return;
    _processingStatus[intakeId] = true;
    final newStatus = !drug.isTaken;
    setState(() {
      drug.isTaken = newStatus;
    });


    widget.onDrugStatusChanged?.call();
    try {
      await _service.updateDrugStatusById(intakeId, newStatus);
    } catch (e) {
      setState(() {
        drug.isTaken = !newStatus;
      });
      widget.onDrugStatusChanged?.call();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка: $e')),
        );
      }
    } finally {
      _processingStatus[intakeId] = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.selectedDate ?? DateTime.now();

    final isToday =
        date.year == DateTime.now().year &&
            date.month == DateTime.now().month &&
            date.day == DateTime.now().day;

    final today = isToday
        ? 'Сегодня, ${DateFormatter.formatDateWithoutYear(date)}'
        : DateFormatter.formatDateWithoutYear(date);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 35, right: 35, top: 16, bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.backgroundUp,
            offset: Offset(0, -8),
            blurRadius: 31,
            spreadRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            today,
            style: AppTextStyles.menuHeadline
          ),
          const SizedBox(height: 15),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_todayDrugs.isEmpty)
            Text(
              'Нет запланированных приемов',
              style: AppTextStyles.notificationGrey,
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _todayDrugs.length,
                itemBuilder: (context, i) {
                  return Column(
                    children: [
                      _buildDrugItem(_todayDrugs[i]),
                      if (i != _todayDrugs.length - 1)
                        const SizedBox(height: 15),
                    ],
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDrugItem(DrugInfo drug) {
    return Container(
      key: ValueKey('drug_${drug.scheduledIntakeId}_${drug.isTaken}'),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.borderColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              drug.intakeTime.substring(0, 5),
              style: AppTextStyles.contentText.copyWith(fontSize: 18)
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => _toggleDrugStatus(drug),
                    borderRadius: BorderRadius.circular(30),
                    splashColor: ColorHelper.hexToColor(drug.colorHex),
                    highlightColor: ColorHelper.hexToColor(drug.colorHex),
                    child: Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(7),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(
                            color: ColorHelper.hexToColor(drug.colorHex),
                            width: 5.0,
                          ),
                        ),
                        child: drug.isTaken
                            ? const CustomPaint(
                          size: Size(20, 20),
                          painter: BoldCheckmarkPainter(),
                        )
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 17),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            drug.formType ?? '—',
                            style: AppTextStyles.contentTextGrey,
                          ),
                          Text(
                            '${drug.amount != null
                                ? (drug.amount! % 1 == 0
                                ? drug.amount!.toInt()
                                : drug.amount!)
                                : ''} ${drug.unit ?? ''}',
                            style: AppTextStyles.contentText.copyWith(fontSize: 15),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              drug.name,
                              style: AppTextStyles.contentText.copyWith(fontSize: 18)
                            ),
                          ),
                          if (drug.foodRule != null && drug.foodRule!.isNotEmpty)
                            Text(
                              drug.foodRule!,
                              style: AppTextStyles.contentText
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }




}
