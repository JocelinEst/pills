import 'package:flutter/material.dart';
import 'package:pills/router/routes.dart';

import 'features/main_screen/widgets/gradient_background.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GradientBackground(
    child: MaterialApp(
      title: 'Happy Pills',
      routes: routes,
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
      ),
    )
    );
  }
}

