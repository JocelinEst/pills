import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pills/themes/style.dart';


class MenuWidget extends StatelessWidget {
  final VoidCallback? onPlanOpened;
  const MenuWidget({
    super.key,
    this.onPlanOpened,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.white,
        child: Stack(
          children: [

            Positioned(
              right: -70,
              top: -60,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backCircleColor,
                    width: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              left: -120,
              bottom: 440,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backCircleColor,
                    width: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              right: -100,
              bottom: 180,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backCircleColor,
                    width: 25,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 160,
              bottom: -90,
              child: Container(
                width: 250,
                height: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.backCircleColor,
                    width: 25,
                  ),
                ),
              ),
            ),

            Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(30, 36, 16, 16),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "<",
                            style: GoogleFonts.montserratAlternates(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: AppColors.backgroundUp,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Меню',
                        style: AppTextStyles.menuHeadline
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(left: 14),
                    children: [
                      _buildMenuItem(context, title: 'Календарь'),
                      const SizedBox(height: 8),
                      _buildMenuItem(context, title: 'План'),
                      const SizedBox(height: 8),
                      _buildMenuItem(context, title: 'Схемы приема'),
                      const SizedBox(height: 8),
                      _buildMenuItem(context, title: 'Препараты'),
                      const SizedBox(height: 8),
                      _buildMenuItem(context, title: 'Статистика'),
                      const SizedBox(height: 8),
                      _buildMenuItem(context, title: 'Настройки'),
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

  Widget _buildMenuItem(BuildContext context, {
    required String title,
  }) {
    return ListTile(
      title: Text(
        title,
        style: AppTextStyles.menuItem
      ),
      onTap: () {
        Navigator.pop(context);
        switch (title) {
          case 'Календарь':
            Navigator.popUntil(context, (route) => route.isFirst);
            break;
          case 'Препараты':
            Navigator.pushNamed(context, '/drugs');
            break;
          case 'Статистика':
            break;
          case 'Настройки':
            break;
          case 'План':
            Navigator.pushNamed(context, '/plan');
            onPlanOpened?.call();
            break;
          case 'Схемы приема':
            Navigator.pushNamed(context, '/intakePlans');

            break;
        }
      },
    );
  }
}