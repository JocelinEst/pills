import 'package:flutter/material.dart';
import '../../../themes/style.dart';

class GradientConstants {

  static const double startStop = 0.0;
  static const double endStop = 0.75;
  static const double circleBorderWidth = 42.0;
  static const double circleOpacity = 0.1;


  static const Color circleBorderColor = Color(0x1AFFFFFF);
}

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool animated;

  const GradientBackground({
    Key? key,
    required this.child,
    this.animated = false,
  }) : super(key: key);

  static const LinearGradient _gradient = LinearGradient(
    colors: [AppColors.backgroundUp, AppColors.backgroundDown],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [GradientConstants.startStop, GradientConstants.endStop],
  );

  static const BoxDecoration _gradientDecoration = BoxDecoration(
    gradient: _gradient,
  );

  static const BorderSide _circleBorder = BorderSide(
    color: GradientConstants.circleBorderColor,
    width: GradientConstants.circleBorderWidth,
  );

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      textDirection: TextDirection.ltr,
      fit: StackFit.expand,
      children: [
        Container(decoration: _gradientDecoration),


        Positioned(
          top: -screenSize.height * 0.03,
          left: screenSize.width * 0.4,
          child: Container(
            width: screenSize.width * 0.9,
            height: screenSize.width * 0.9,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              border: Border.fromBorderSide(_circleBorder),
            ),
          ),
        ),

        child,
      ],
    );
  }


}