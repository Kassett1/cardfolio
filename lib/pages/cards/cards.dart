import 'package:cardfolio/pages/cards/widgets/extension_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cardfolio/models/pokemon_set.dart';
import 'package:cardfolio/services/tcg_api.dart';
import 'package:cardfolio/utils/helpers.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Cartes',
          style: const TextStyle(fontFamily: 'LuckiestGuy', fontSize: 30),
        ),
        actions: [
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
        future: TcgApi().fetchSets(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erreur : ${snapshot.error}"));
          }

          final sets = snapshot.data!;
          final grouped = groupAndSortByBloc(sets);

          return SingleChildScrollView(
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
