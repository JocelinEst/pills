import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'package:pills/models/view.dart';
import 'package:pills/services/view.dart';
import 'package:pills/utils/color_helper.dart';
import 'package:pills/themes/style.dart';
import '../../main_screen/widgets/view.dart';
import '../../menu_screen/widgets/view.dart';

class EditDrugWidget extends StatefulWidget {
  final DrugInfo drug;
  final VoidCallback? onSaved;

  const EditDrugWidget({
    super.key,
    required this.drug,
    this.onSaved,
  });

  @override
  State<EditDrugWidget> createState() => _EditDrugWidgetState();
}

class _EditDrugWidgetState extends State<EditDrugWidget> {
  final DrugService _service = DrugService();

  late TextEditingController _name;
  late TextEditingController _quantity;
  late TextEditingController _prescription;

  List<DrugType> _types = [];
  DrugType? _selectedType;

  bool _loading = false;
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadTypes();
    _name = TextEditingController(text: widget.drug.name);
    _quantity = TextEditingController(
      text: widget.drug.quantityInPackage.toString(),
    );
    _prescription = TextEditingController(
      text: widget.drug.prescription ?? '',
    );
    _selectedColor = ColorHelper.hexToColor(widget.drug.colorHex);
  }

  Future<void> _loadTypes() async {
    final result = await _service.getDrugTypesTyped();
    setState(() {
      _types = result;
      final defaultTypeId = widget.drug.drugTypeId;
      if (defaultTypeId != null) {
        _selectedType = _types.firstWhere(
              (t) => t.id == defaultTypeId,
          orElse: () => _types.first,
        );
      } else if (_types.isNotEmpty) {
        _selectedType = _types.first;
      }
    });
  }

  Future<void> _save() async {
    if (_selectedType == null) return;

    setState(() => _loading = true);

    try {
      print('DEBUG SAVE START');

      await _service.updateDrug(
        id: widget.drug.id!,
        name: _name.text,
        colorHex: ColorHelper.colorToHex(_selectedColor),
        drugTypeId: _selectedType!.id,
        quantityInPackage: int.tryParse(_quantity.text) ?? 0,
        prescription: _prescription.text,
      );

      print('DEBUG SAVE SUCCESS');

      widget.onSaved?.call();

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('DEBUG SAVE ERROR: $e');
    }

    if (mounted) {
      setState(() => _loading = false);
    }
  }

  Future<void> _delete() async {
    print('DEBUG: Checking intake history for drug ID: ${widget.drug.id}');
    final hasHistory = await _service.hasIntakeHistory(widget.drug.id!);
    print('DEBUG: hasHistory = $hasHistory');
    if (hasHistory) {
      print('DEBUG: Showing error dialog');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Невозможно удалить препарат: есть история приемов',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );

        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Невозможно удалить'),
            content: const Text(
              'Этот препарат имеет историю приемов.\n'
                  'Удаление недоступно.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Понятно'),
              ),
            ],
          ),
        );
      }
      return;
    }

    final confirm = await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Удалить препарат?'),
        content: const Text('Это действие нельзя отменить'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _loading = true);
      try {
        await _service.deleteDrug(widget.drug.id!);
        widget.onSaved?.call();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Препарат успешно удален'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка при удалении: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const MenuWidget(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MenuButtonWidget(iconPath: 'assets/images/menu_icon_blue.png'),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Редактирование препарата',
                style: AppTextStyles.screenHeadline,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        labelText: "Название",
                        labelStyle: AppTextStyles.commonText,
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _quantity,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        labelText: "Количество в упаковке",
                        labelStyle: AppTextStyles.commonText,
                      ),
                      style: AppTextStyles.commonText,
                    ),
                    const SizedBox(height: 25),
                    Text(
                      "Цвет препарата",
                      style: AppTextStyles.commonText,
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _pickColor,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: _selectedColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    TextField(
                      controller: _prescription,
                      decoration: InputDecoration(
                        labelText: "Рецепт",
                        labelStyle: AppTextStyles.commonText,
                      ),
                    ),
                    const SizedBox(height: 20),
                    DropdownButton<DrugType>(
                      value: _selectedType,
                      isExpanded: true,
                      hint: Text(
                        "Тип препарата",
                        style: AppTextStyles.commonText,
                      ),
                      items: _types.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            "${type.name} (${type.measurement})",
                            style: AppTextStyles.commonText,
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedType = value;
                        });
                      },
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _save,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.backgroundUp,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: _loading
                              ? const CircularProgressIndicator()
                              : Text(
                            'Сохранить',
                            style: AppTextStyles.cardHeadline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _delete,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          child: Text(
                            'Удалить',
                            style: AppTextStyles.cardHeadline,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickColor() async {
    Color tempColor = _selectedColor;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Выберите цвет"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                tempColor = color;
              },
            ),
          ),
          actions: [
            TextButton(
              child: const Text("Готово"),
              onPressed: () {
                setState(() {
                  _selectedColor = tempColor;
                });
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}