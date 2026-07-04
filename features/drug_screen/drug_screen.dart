import 'package:flutter/material.dart';
import 'package:pills/features/drug_screen/widgets/view.dart';
import 'package:pills/services/view.dart';
import 'package:pills/features/main_screen/widgets/view.dart';

import '../../models/view.dart';
import '../../themes/style.dart';
import '../button_widgets/view.dart';
import '../menu_screen/widgets/view.dart';

class DrugWidget extends StatefulWidget {
  final VoidCallback? onGlobalRefresh;
  const DrugWidget({
    super.key,
    this.onGlobalRefresh,

  });

  @override
  State<DrugWidget> createState() => _DrugWidgetState();
}

class _DrugWidgetState extends State<DrugWidget> {
  final DrugService _service = DrugService();
  List<DrugInfo> _filteredDrugs = [];
  List<DrugInfo> _rawDrugs = [];
  bool _isLoading = true;

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<String> _selectedDrugTypes = [];
  List<String> _drugTypes = [];

  @override
  void initState() {
    super.initState();
    _loadDrugs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDrugs() async {
    try {
      final drugs = await _service.getAllDrugsFull();
      final types = await _service.getDrugTypesTyped();

      setState(() {
        _rawDrugs = drugs;
        _drugTypes = types.map((t) => t.name).toList();
        _isLoading = false;
      });

      _filterDrugs();
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterDrugs() {
    setState(() {
      _filteredDrugs = _rawDrugs.where((drug) {
        final nameMatch = _searchQuery.isEmpty ||
            drug.name.toLowerCase().contains(_searchQuery.toLowerCase());

        final typeMatch = _selectedDrugTypes.isEmpty ||
            _selectedDrugTypes.contains(drug.formType);

        return nameMatch && typeMatch;
      }).toList();
    });
  }

  void _onSearchChanged(String query) {
    _searchQuery = query;
    _filterDrugs();
  }

  void _onTypeFilterChanged(List<String> types) {
    _selectedDrugTypes = types;
    _filterDrugs();
  }

  Future<void> _onAddPressed() async {
    final result = await Navigator.pushNamed(context, '/addDrug');
    if (result == true) _loadDrugs();
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
            MenuButtonWidget( iconPath: 'assets/images/menu_icon_blue.png'),

            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Препараты',
                    style: AppTextStyles.screenHeadline,

                  ),

                  AddButton(
                    onTap: _onAddPressed,
                  ),
                ],
              ),
            ),

            DrugSearchField(
              controller: _searchController,
              onChanged: _onSearchChanged,
            ),

            DrugTypeFilter(
              drugTypes: _drugTypes,
              selectedTypes: _selectedDrugTypes,
              onChanged: _onTypeFilterChanged,
            ),

            const SizedBox(height: 8),

            Expanded(
              child: _filteredDrugs.isEmpty
                  ? const Center(child: Text('Нет препаратов'))
                  : ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _filteredDrugs.length,
                itemBuilder: (context, i) {
                  final drug = _filteredDrugs[i];
                  return DrugCard(
                    drug: drug,
                    onEdit: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        '/editDrug',
                        arguments: drug,
                      );

                      if (result == true) {
                        await _loadDrugs();
                        widget.onGlobalRefresh?.call();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}