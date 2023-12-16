import 'package:flutter/material.dart';
import 'package:todo_app/TodoList.dart';
import 'package:todo_app/DatabaseHelper.dart';
import 'SplashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.initDb();
  runApp(MyApp(dbHelper: dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  MyApp({required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'To-Do-List', home: SplashScreen(dbHelper: dbHelper));
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      dbHelper.closeDb();
    }
  }
}
