import 'package:cardfolio/pages/cards/widgets/extension_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

      body: SingleChildScrollView(
        child: Stack(
          children: [
            SvgPicture.asset(
              'assets/icons/line.svg',
              width: MediaQuery.of(context).size.width,
            ),
            Positioned(
              bottom: 100,
              child: SvgPicture.asset(
                'assets/icons/line.svg',
                width: MediaQuery.of(context).size.width,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  ExtensionList(
                    title: 'Écarlate et Violet',
                    items: [
                      'SV Base',
                      'SV Paldea Evolved',
                      'SV Obsidian Flames',
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
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
