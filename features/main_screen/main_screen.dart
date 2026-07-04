import 'package:flutter/material.dart';
import 'package:pills/features/menu_screen/menu_widget.dart';
import 'package:pills/features/main_screen/widgets/panel_widget.dart';
import '../plan_screen/plan_screen.dart';
import 'widgets/calendar_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key, required this.title
  });
  final String title;
  @override
  State<MainScreen> createState() => _MainScreenState();
}
class _MainScreenState extends State<MainScreen> {
  late PageController _pageController;
  final DateTime _today = DateTime.now();
  final GlobalKey<CalendarWidgetState> _calendarKey = GlobalKey();

  DateTime? _selectedDate;
  int _globalRefreshKey = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1000);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshAll();
    });
  }
  DateTime _getDateForIndex(int index) {
    int monthOffset = index - 1000;
    return DateTime(
      _today.year,
      _today.month + monthOffset,
      1,
    );
  }
  void _refreshAll() {
    setState(() {
      _globalRefreshKey++;
    });

    _calendarKey.currentState?.refreshCalendar();
  }
  int _getDaysInMonth(DateTime date) {
    DateTime lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    return lastDayOfMonth.day;
  }

  String _getMonthName(DateTime date) {
    List<String> months = [
      'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
      'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
    ];
    return months[date.month - 1];
  }
  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MenuWidget(
        onPlanOpened: _openPlanWidget,
      ),
      body: Builder(
        builder: (context) => Column(
          children: [
            const SizedBox(height: 26),

            Expanded(flex: 25, child: Container()),

            Container(
              padding: const EdgeInsets.only(left: 26, right: 3, bottom: 10),
              child: InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Align(
                  alignment: Alignment.topLeft,
                  child: Image(
                    image: AssetImage('assets/images/menu_icon.png'),
                    width: 39,
                    height: 34,
                  ),
                ),
              ),
            ),

            Expanded(
              flex: 500,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                child: PageView.builder(
                  controller: _pageController,
                  itemBuilder: (context, index) {
                    DateTime date = _getDateForIndex(index);
                    return CalendarWidget(
                      key: ValueKey('${date.year}-${date.month}-$_globalRefreshKey'),
                      daysInMonth: _getDaysInMonth(date),
                      nameOfMonth: _getMonthName(date),
                      year: date.year,
                      displayedDate: date,
                      onDateSelected: _onDateSelected,
                    );
                  },
                ),
              ),
            ),

            Expanded(flex: 30, child: Container()),

            Expanded(
              flex: 350,
              child: Container(
                padding: EdgeInsets.zero,

                child:
                PanelOfTheDay(
                  key: ValueKey(_globalRefreshKey),
                  onDrugStatusChanged: _refreshAll,
                  selectedDate: _selectedDate,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _openPlanWidget() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PlanWidget()),
    );

    _refreshAll();
  }

}