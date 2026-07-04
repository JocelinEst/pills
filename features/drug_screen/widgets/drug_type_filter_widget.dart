import 'package:flutter/material.dart';
import 'package:pills/themes/style.dart';

class DrugTypeFilter extends StatelessWidget {
  final List<String> drugTypes;
  final List<String> selectedTypes;
  final ValueChanged<List<String>> onChanged;

  const DrugTypeFilter({
    super.key,
    required this.drugTypes,
    required this.selectedTypes,
    required this.onChanged,
  });

  String get displayText {
    if (selectedTypes.isEmpty) return 'Все типы';
    return selectedTypes.join(' ');
  }

  void _openSelector(BuildContext context) async {
    final temp = List<String>.from(selectedTypes);

    final result = await showModalBottomSheet<List<String>>(
      context: context,
      backgroundColor: Colors.white,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                const SizedBox(height: 12),
                Text(
                    'Типы препаратов',
                  style: AppTextStyles.menuHeadline,
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 50),
                    children: drugTypes.map((type) {
                      final selected = temp.contains(type);

                      return CheckboxListTile(
                        title: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.appGrey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                type,
                                style: AppTextStyles.tagText,
                              ),
                            ),
                          ],
                        ),
                        value: selected,
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        onChanged: (v) {
                          setState(() {
                            if (v == true) {
                              temp.add(type);
                            } else {
                              temp.remove(type);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context, temp),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundUp,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Text(
                        'Применить',
                        style: AppTextStyles.cardHeadline,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      onChanged(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () => _openSelector(context),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.borderColor,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: selectedTypes.isEmpty
                  ? [
                Text(
                  'Все типы',
                  style: AppTextStyles.contentText,
                ),
              ]
                  : selectedTypes.map((type) {
                return Container(
                  margin: const EdgeInsets.only(right: 6),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.appGrey,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    type,
                    style: AppTextStyles.contentText,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}