import 'package:flutter/material.dart';
import 'package:cardfolio/pages/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ExtensionList extends StatefulWidget {
  const ExtensionList({
    super.key,
    required this.title,
    required this.items,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String title;
  final List<String> items;
  final EdgeInsetsGeometry padding;

  @override
  State<ExtensionList> createState() => _ExtensionListState();
}

class _ExtensionListState extends State<ExtensionList>
    with TickerProviderStateMixin {
  bool _open = false; // fermé par défaut

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: _open
                ? [
                    AppColors.secondary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0.6),
                  ]
                : [
                    AppColors.secondary.withValues(alpha: 0.2),
                    AppColors.secondary.withValues(alpha: 0.6),
                  ],
            center: Alignment.topLeft,
            radius: 1.2,
          ),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.secondary.withValues(alpha: 0.2),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header cliquable (titre + flèche)
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () => setState(() => _open = !_open),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: 'LuckiestGuy',
                        fontSize: 18,
                        color: AppColors.text,
                      ),
                    ),
                    AnimatedRotation(
                      turns: _open ? 0.0 : 0.5,
                      duration: const Duration(milliseconds: 200),
                      child: SvgPicture.asset(
                        'assets/icons/arrow.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Contenu dépliable animé
              AnimatedSize(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                child: _open
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.items
                            .map(
                              (t) => Padding(
                                padding: const EdgeInsets.only(top: 6),
                                child: Text(
                                  t,
                                  style: const TextStyle(color: AppColors.text),
                                ),
                              ),
                            )
                            .toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
