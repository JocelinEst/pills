import 'package:flutter/material.dart';

class MenuButtonWidget extends StatelessWidget {
  final String iconPath;

  const MenuButtonWidget({
    super.key,
    required this.iconPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: 26,
        right: 3,
        bottom: 10,
      ),
      child: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Align(
          alignment: Alignment.topLeft,
          child: Image.asset(
            iconPath,
            width: 39,
            height: 34,
          ),
        ),
      ),
    );
  }
}