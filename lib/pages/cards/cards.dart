import 'package:cardfolio/pages/cards/widgets/extension_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardfolio/models/pokemon_set.dart';
import 'package:cardfolio/services/tcg_api.dart';
import 'package:cardfolio/utils/helpers.dart';

class CardsPage extends StatefulWidget {
  const CardsPage({super.key});

  @override
  State<CardsPage> createState() => _CardsPageState();
}

class _CardsPageState extends State<CardsPage> {
  final _api = TcgApi();

  late Future<List<PokemonSet>> _futureSets;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _futureSets = _api.getSetsFromCache();
  }

  Future<void> _onRefreshPressed() async {
    if (_isRefreshing) return;

    setState(() => _isRefreshing = true);

    try {
      final fresh = await _api.forceRefresh();
      setState(() {
        _futureSets = Future.value(fresh);
        _isRefreshing = false;
      });
    } catch (e) {
      setState(() => _isRefreshing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du rafraîchissement : $e')),
      );
    }
  }

  /// 🔹 Nouveau : vider le cache local
  Future<void> _onClearCachePressed() async {
    await _api.clearSetsCache();
    setState(() {
      _futureSets = Future.value([]); // on vide les données affichées
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cache vidé ✅')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: Text(
          'Cartes',
          style: const TextStyle(
            fontFamily: 'LuckiestGuy',
            fontSize: 30,
          ),
        ),
        actions: [
          // Bouton refresh (avec spinner si en cours)
          IconButton(
            tooltip: 'Rafraîchir les sets depuis l’API',
            onPressed: _onRefreshPressed,
            icon: _isRefreshing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh, size: 24),
          ),

          // 🔹 Nouveau : bouton pour vider le cache
          IconButton(
            tooltip: 'Vider le cache local',
            onPressed: _onClearCachePressed,
            icon: const Icon(Icons.delete_outline, size: 24),
          ),

          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/profile.svg',
              width: 24,
              height: 24,
            ),
            tooltip: 'Profil',
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              width: 28,
              height: 28,
            ),
            tooltip: 'Paramètres',
            onPressed: () {},
          ),
        ],
      ),

      body: FutureBuilder<List<PokemonSet>>(
        future: _futureSets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return SafeArea(
              child: _ErrorView(
                message: "Erreur : ${snapshot.error}",
                isRefreshing: _isRefreshing,
                onRetry: _onRefreshPressed,
              ),
            );
          }

          final sets = snapshot.data ?? [];

          if (sets.isEmpty) {
            if (_isRefreshing) {
              return const Center(child: CircularProgressIndicator());
            }

            return SafeArea(
              child: _EmptyCacheView(onRefresh: _onRefreshPressed),
            );
          }

          final grouped = groupAndSortByBloc(sets);

          return Stack(
            children: [
              SingleChildScrollView(
                child: SafeArea(
                  child: Column(
                    children: grouped.entries.map((entry) {
                      return ExtensionList(
                        title: entry.key,
                        items: entry.value.map((s) => s.name).toList(),
                      );
                    }).toList(),
                  ),
                ),
              ),
              if (_isRefreshing)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Mise à jour…",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),

      bottomNavigationBar: NavigationBar(),
    );
  }

  Widget NavigationBar() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
          label: 'cards',
          icon: SvgPicture.asset(
            'assets/icons/cards.svg',
            width: 28,
            height: 28,
          ),
        ),
        BottomNavigationBarItem(
          label: 'sealed',
          icon: SvgPicture.asset(
            'assets/icons/sealed.svg',
            width: 28,
            height: 28,
          ),
        ),
        BottomNavigationBarItem(
          label: 'accessories',
          icon: SvgPicture.asset(
            'assets/icons/accessories.svg',
            width: 28,
            height: 28,
          ),
        ),
      ],
    );
  }
}

class _EmptyCacheView extends StatelessWidget {
  final VoidCallback onRefresh;
  const _EmptyCacheView({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Aucune extension en cache.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            const Text(
              "Appuie sur le bouton pour récupérer les sets depuis l'API.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRefresh,
              icon: const Icon(Icons.refresh),
              label: const Text("Rafraîchir maintenant (c'est long)"),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final bool isRefreshing;
  final VoidCallback onRetry;
  const _ErrorView({
    required this.message,
    required this.isRefreshing,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isRefreshing) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text("Réessayer"),
            ),
          ],
        ),
      ),
    );
  }
}
