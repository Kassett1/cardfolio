import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cardfolio/models/pokemon_set.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class TcgApi {
  static const _base = 'https://api.pokemontcg.io/v2';

  Map<String, String> get _headers => {
    'X-Api-Key': dotenv.env['POKEMON_TCG_API_KEY'] ?? '',
  };

  Future<List<PokemonSet>> fetchSets() async {
    final uri = Uri.parse('$_base/sets');

    // print("➡️ Requête API: $uri");

    try {
      final res = await http
          .get(uri, headers: _headers);

      // print("⬅️ Réponse status: ${res.statusCode}");

      if (res.statusCode != 200) {
        // print("❌ Erreur réponse: ${res.body}");
        throw Exception('HTTP ${res.statusCode}: ${res.body}');
      }

      final map = jsonDecode(res.body) as Map<String, dynamic>;
      final list = (map['data'] as List).cast<Map<String, dynamic>>();

      // print("✅ Nombre de sets reçus: ${list.length}");

      return list.map(PokemonSet.fromJson).toList();
    } catch (e) {
      // print("🔥 Erreur fetchSets: $e");
      rethrow; // on renvoie l'erreur pour que FutureBuilder la capte
    }
  }
}
