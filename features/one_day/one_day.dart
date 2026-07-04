import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pills/themes/style.dart';
import 'package:pills/models/view.dart';

class OneDay extends StatefulWidget {
  final String dayNumber;
  final bool isToday;
  final bool isPast;
  final VoidCallback? onTap;
  final VoidCallback? onDaySelected;
  final List<DrugInfo> drugs;

  const OneDay({
    super.key,
    required this.dayNumber,
    this.isToday = false,
    this.isPast = false,
    this.onTap,
    this.drugs = const [],
    this.onDaySelected,
  });

  @override
  State<OneDay> createState() => _OneDayState();
}

class _OneDayState extends State<OneDay> {
  bool get _isSelectable => !widget.isPast && widget.onTap != null;

  void _handleTap() {
    if (_isSelectable) {
      widget.onTap?.call();
    }
    widget.onDaySelected?.call();
  }

  Color get _backgroundColor {
    if (widget.isToday) return AppColors.todayBack;
    return AppColors.defaultBackground;
  }

  Color get _textColor {
    if (widget.isToday) return AppColors.todayFont;
    if (widget.isPast) return AppColors.pastText;
    return AppColors.defaultText;
  }

  int _toMinutes(String t) {
    final parts = t.split(':');
    if (parts.length < 2) return 0;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  Color _getCircleColor(DrugInfo drug) {
    if (drug.isTaken) {
      return const Color(0xFFC2FF87);
    }
    if (widget.isPast) {
      return Colors.grey;
    }
    return _parseColor(drug.colorHex);
  }

  Color _parseColor(String hexCode) {
    final buffer = StringBuffer();
    if (hexCode.length == 7 && hexCode[0] == '#') {
      buffer.write(hexCode.substring(1, 7));
    } else {
      buffer.write(hexCode);
    }
    return Color(int.parse('FF${buffer.toString()}', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final h = constraints.maxHeight;
        final fontSize = w * 0.28;
        final circleSize = w * 0.22;
        final sortedDrugs = [...widget.drugs]
          ..sort((a, b) => _toMinutes(a.intakeTime)
              .compareTo(_toMinutes(b.intakeTime)));

        return GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: w,
            height: h,
            padding: EdgeInsets.only(
              top: w * 0.05,
              left: w * 0.08,
              bottom: w * 0.05,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(w * 0.1),
              color: _backgroundColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.dayNumber,
                  style: GoogleFonts.montserratAlternates(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w700,
                    color: _textColor,
                  ),
                ),
                if (sortedDrugs.isNotEmpty)
                  SizedBox(
                    height: circleSize,
                    child: Stack(
                      children: List.generate(sortedDrugs.length, (index) {
                        final drug = sortedDrugs[index];
                        return Positioned(
                          left: index * (circleSize * 0.55),
                          child: Container(
                            width: circleSize,
                            height: circleSize,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _getCircleColor(drug),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.5,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}