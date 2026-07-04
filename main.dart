import 'package:flutter/material.dart';
import 'app.dart';
import 'database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = DatabaseHelper.instance;
  await db.database;
  runApp(const MyApp());
}


