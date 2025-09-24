import 'package:flutter/material.dart';
import 'package:cardfolio/pages/constants/app_colors.dart';


class ExtensionList extends StatelessWidget {
  final String title;
  final List<String> items;
  final EdgeInsetsGeometry padding; // pour contrôler le padding depuis le parent

  const ExtensionList({
    super.key,
    required this.title,
    required this.items,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 12,
    ), // ~ padding AppBar
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'LuckiestGuy',
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ...items.map(
                (t) => Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(t, style: const TextStyle(color: Colors.white70)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
