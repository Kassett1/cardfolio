import 'package:flutter/material.dart';
import 'package:cardfolio/pages/constants/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardfolio/models/pokemon_set.dart';

class ExtensionList extends StatefulWidget {
  const ExtensionList({
    super.key,
    required this.title,
    required this.sets,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  });

  final String title; // Nom du bloc (ex: "Écarlate & Violet")
  final List<PokemonSet> sets; // Les sets du bloc (on a accès à symbol)
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
                    ? Wrap(
                        spacing: 12, // espace horizontal entre symboles
                        runSpacing: 12, // espace vertical entre lignes
                        children: widget.sets.map((set) {
                          return _SetSymbolBadge(symbolUrl: set.symbol);
                        }).toList(),
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

// Petit carré qui affiche juste le symbole du set
class _SetSymbolBadge extends StatelessWidget {
  final String symbolUrl;
  const _SetSymbolBadge({required this.symbolUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: _buildSymbol(symbolUrl),
    );
  }

  Widget _buildSymbol(String url) {
    // Si c'est un SVG
    if (url.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        width: 32,
        height: 32,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => const SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }

    // Sinon image bitmap
    return Image.network(
      url,
      width: 32,
      height: 32,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(
        Icons.broken_image,
        size: 20,
        color: Colors.redAccent,
      ),
    );
  }
}
