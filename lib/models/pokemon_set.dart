class PokemonSet {
  final String id;      // ex: "swsh1"
  final String name;    // ex: "Sword & Shield"
  final String series;  // ex: "Sword & Shield"
  final String symbol;  // ex: URL du symbole

  PokemonSet({
    required this.id,
    required this.name,
    required this.series,
    required this.symbol,
  });

  factory PokemonSet.fromJson(Map<String, dynamic> json) {
    return PokemonSet(
      id: json['id'] as String,
      name: json['name'] as String,
      series: json['series'] as String,
      symbol: (json['images']?['symbol'] ?? '') as String,
    );
  }
}
