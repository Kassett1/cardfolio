import 'package:flutter/material.dart';
import 'package:cardfolio/pages/cards/cards.dart';
import 'package:cardfolio/pages/constants/app_colors.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


Future<void> main() async {
  // On charge le .env AVANT runApp
  await dotenv.load(fileName: ".env");

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cardfolio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background, // fond global
        primaryColor: AppColors.primary, // couleur "principale"
        iconTheme: IconThemeData(color: AppColors.primary), // icônes globales
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: AppColors.text), // texte par défaut
          bodyLarge: TextStyle(color: AppColors.primary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.primary, // AppBar aussi
          elevation: 0,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.transparent,
          selectedItemColor: AppColors.primary,
          elevation: 0,
          showSelectedLabels: false,
          showUnselectedLabels: false,
        ),
      ),
      home: CardsPage(),
    );
  }
}
