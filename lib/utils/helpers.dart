import 'package:cardfolio/models/pokemon_set.dart';

/// Normalise une chaîne pour matcher (minuscules, enlève espaces et caractères spéciaux simples).
String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9&]'), '');

/// Organise les noms des anciens blocs.
String resolveBlocFromSeries(String seriesRaw) {
  final s = _norm(seriesRaw);

  // Wizards = Base, Gym, Neo, E-cards
  if (s.contains('base') ||
      s.contains('gym') ||
      s.contains('neo') ||
      s.contains('e-card')) {
    return 'Wizards';
  }

  // Other = Other, NP, Pop
  if (s == 'other' || s == 'np' || s == 'pop') {
    return 'Other';
  }

  // Par défaut: on garde le nom original tel quel
  return seriesRaw;
}

/// Regroupe les sets par bloc (via resolveBlocFromSeries) puis RENVOIE une map ORDONNÉE du plus récent au plus ancien, avec "Other" en dernier.
Map<String, List<PokemonSet>> groupAndSortByBloc(
  List<PokemonSet> sets,
) {
  final Map<String, List<PokemonSet>> tmp = {};
  for (final s in sets) {
    final bloc = resolveBlocFromSeries(s.series);
    tmp.putIfAbsent(bloc, () => []);
    tmp[bloc]!.add(s);
  }

  // 🔹 On inverse chaque liste de sets
  tmp.updateAll((key, list) => list.reversed.toList());

  // On sépare "Other" des autres blocs
  final others = tmp.entries.where((e) => e.key == "Other").toList();
  var rest = tmp.entries.where((e) => e.key != "Other").toList();

  // On inverse l'ordre pour avoir du plus récent au plus ancien
  rest = rest.reversed.toList();

  // On reconstruit en ajoutant "Other" à la fin
  final ordered = <String, List<PokemonSet>>{};
  for (final e in rest) {
    ordered[e.key] = e.value;
  }
  for (final e in others) {
    ordered[e.key] = e.value;
  }

  return ordered;
}

