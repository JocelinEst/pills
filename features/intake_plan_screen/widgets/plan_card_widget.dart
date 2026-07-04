import 'package:flutter/material.dart';
import 'package:pills/models/view.dart';
import '../../../models/dosage_scheme_item.dart';
import '../../../themes/style.dart';
import '../../../utils/color_helper.dart';
import '../../../utils/food_rule_helper.dart';

class PlanCard extends StatelessWidget {
  final IntakePlanFull plan;
  final String Function(DateTime) formatDate;


  const PlanCard({
    super.key,
    required this.plan,
    required this.formatDate,

  });


  int _getUniqueDaysCount() {
    final Set<int> days = {};

    for (final item in plan.dosageScheme) {
      days.add(item.dayFromStart);
    }

    return days.length;
  }

  bool get _showScheme => _getUniqueDaysCount() > 1;

  @override
  Widget build(BuildContext context) {
    String dateText;

    if (plan.endDate != null) {
      dateText =
      "${formatDate(plan.startDate)} - ${formatDate(plan.endDate!)}";
    } else {
      dateText =
      "На постоянной основе с ${formatDate(plan.startDate)}";
    }

    return Card(
      margin: const EdgeInsets.all(8),
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            childrenPadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 25,
                  height: 25,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorHelper.hexToColor(plan.colorHex),
                    border: Border.all(
                      color: ColorHelper.hexToColor(plan.colorHex),
                      width: 2,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.drugName,
                        style: AppTextStyles.cardHeadline,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dateText,
                        style: AppTextStyles.commonText,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            children: [
              const SizedBox(height: 8),

              if (_showScheme)
                Padding(
                  padding: const EdgeInsets.only(left: 4, bottom: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildDosageScheme(),
                  ),
                )
              else
                _buildSchedules(),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSchedules() {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: plan.schedules.map((s) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.time,
                  style: AppTextStyles.cardHeadline,
                ),

                const SizedBox(height: 8),

                if (s.days != null && s.days!.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: s.days!
                        .split(', ')
                        .map(
                          (day) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          day,
                          style: AppTextStyles.contentText,
                        ),
                      ),
                    )
                        .toList(),
                  ),

                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (s.foodRule != null && s.foodRule!.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: FoodRuleHelper.getBackgroundColor(s.foodRule!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          s.foodRule!,
                          style: AppTextStyles.contentText.copyWith(
                            color: FoodRuleHelper.getTextColor(s.foodRule!),
                          ),
                        ),
                      ),

                    if (s.dose != null && s.dose!.isNotEmpty) ...[
                      const SizedBox(width: 12),
                      Text(
                        s.dose!,
                        style: AppTextStyles.contentText,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDosageScheme() {
    final Map<int, List<DosageSchemeItem>> grouped = {};

    for (final item in plan.dosageScheme) {
      grouped.putIfAbsent(item.dayFromStart, () => []);
      grouped[item.dayFromStart]!.add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: grouped.entries.map((entry) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'День ${entry.key + 1}',
                style: AppTextStyles.cardHeadline,
              ),

              const SizedBox(height: 12),

              ...entry.value.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      if (item.daysOfWeek != null)
                        Text(
                          item.daysOfWeek!,
                          style: AppTextStyles.contentText,
                        ),

                      Text(
                        item.time,
                        style: AppTextStyles.cardHeadline,
                      ),

                      if (item.foodRule != null)
                        Text(
                          item.foodRule!,
                          style: AppTextStyles.contentText,
                        ),

                      Text(
                        item.dose,
                        style: AppTextStyles.contentText,
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      }).toList(),
    );
  }
}
