import 'package:flutter/material.dart';
import 'package:project_flutter/api_service.dart';
import 'package:project_flutter/home_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await ApiService.getToken();
  
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      home: token != null && token!.isNotEmpty 
          ? const HomeScreen() 
          : const LoginScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}