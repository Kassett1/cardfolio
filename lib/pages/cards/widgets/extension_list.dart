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
          color: _open
              ? AppColors.secondary.withValues(alpha: 0.5)
              : AppColors.background.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _open ? AppColors.secondary : AppColors.primary,
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
                        color: AppColors.primary,
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
                                  style: const TextStyle(color: AppColors.primary),
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
