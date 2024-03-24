import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schedule_courts/view/schedule/list.dart';
import 'helpers/database.dart';
import 'view_model/schedule_view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DBHelper.openDB();
  runApp(const ScheduleApp());
}

class ScheduleApp extends StatelessWidget {
  const ScheduleApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: ScheduleViewModel()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: scheduledScreen(),
      ),
    );
  }
}
