import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter/services.dart';
import 'package:pills/models/view.dart';
import 'package:pills/services/view.dart';
import 'package:pills/themes/style.dart';
import 'package:pills/utils/view.dart';
import '../../main_screen/widgets/view.dart';
import '../../menu_screen/widgets/view.dart';

class AddDrugWidget extends StatefulWidget {
  const AddDrugWidget({super.key});

  @override
  State<AddDrugWidget> createState() => _AddDrugWidgetState();
}

class _AddDrugWidgetState extends State<AddDrugWidget> {
  final DrugService _service = DrugService();

  final TextEditingController _name = TextEditingController();
  final TextEditingController _quantity = TextEditingController();
  final TextEditingController _prescription = TextEditingController();

  List<DrugType> _types = [];
  DrugType? _selectedType;

  bool _loading = false;
  Color _selectedColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _loadTypes();
  }

  Future<void> _loadTypes() async {
    final result = await _service.getDrugTypesTyped();
    setState(() {
      _types = result;
      if (_types.isNotEmpty) {
        _selectedType = _types.first;
      }
    });
  }

  Future<void> _save() async {
    if (_selectedType == null) return;

    setState(() => _loading = true);

    try {
      await _service.createDrug(
        name: _name.text,
        colorHex: ColorHelper.colorToHex(_selectedColor),
        drugTypeId: _selectedType!.id,
        quantityInPackage: int.tryParse(_quantity.text) ?? 0,
        prescription: _prescription.text,
      );

      if (mounted) Navigator.pop(context, true);
    } catch (e) {}

    setState(() => _loading = false);
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
                'Новый препарат',
                style: AppTextStyles.screenHeadline,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16),
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
                            'Создать',
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