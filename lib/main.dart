import 'package:flutter/material.dart';
import 'package:cardfolio/pages/cards/cards.dart';
import 'package:cardfolio/pages/constants/app_colors.dart';

void main() {
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
          bodyMedium: TextStyle(color: AppColors.primary), // texte par défaut
          bodyLarge: TextStyle(color: AppColors.primary),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent,
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
