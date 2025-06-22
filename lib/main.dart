import 'package:flutter/material.dart';
import 'package:emergency_v1/CustomNavigationBar.dart';
import 'Helper Functions/DatabaseHelper.dart';
import 'Helper Functions/SharedPreferenceHelper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  // Ensures that some important services get started early than the app's UI
  await DatabaseHelper().database;
  await SharedPreferenceHelper.init();

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SOS Emergency App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CustomNavigationBar(),
    );
  }
}
