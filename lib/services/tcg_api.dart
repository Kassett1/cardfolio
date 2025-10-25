import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cardfolio/models/pokemon_set.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TcgApi {
  static const _base = 'https://api.pokemontcg.io/v2';
  static const _cacheKeySets = 'sets';

  Map<String, String> get _headers => {
    'X-Api-Key': dotenv.env['POKEMON_TCG_API_KEY'] ?? '',
  };

  /// 1. Lire le cache uniquement (pas d'appel réseau).
  ///    Retourne une liste vide si pas de cache.
  Future<List<PokemonSet>> getSetsFromCache() async {
    final cached = await _loadSetsFromCache();
    return cached ?? [];
  }

  /// 2. Forcer un rafraîchissement depuis l'API.
  /// Met à jour le cache puis renvoie les nouvelles données.
  /// Force un rafraîchissement depuis l'API.
  /// Continue indéfiniment tant qu'une erreur (504 ou autre) empêche la récupération.
  Future<List<PokemonSet>> forceRefresh() async {

    while (true) {
      try {
        final fresh = await _fetchSetsFromApi();
        await _saveSetsToCache(fresh);
        return fresh;
      } catch (e) {
        // on attend un peu avant de retenter (évite de spammer l'API)
        await Future.delayed(const Duration(seconds: 3));
      }
    }
  }

  /// 3. Savoir si on a déjà quelque chose en cache
  Future<bool> hasCache() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cacheKeySets);
  }

  /// 4. Réinitialiser le cache
  Future<void> clearSetsCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKeySets);
  }

  // ---------- PRIVÉ : APPEL API ----------
  Future<List<PokemonSet>> _fetchSetsFromApi() async {
    final uri = Uri.parse('$_base/sets');

    final res = await http.get(uri, headers: _headers);

    if (res.statusCode != 200) {
      throw Exception('HTTP ${res.statusCode}: ${res.body}');
    }

    final map = jsonDecode(res.body) as Map<String, dynamic>;
    final list = (map['data'] as List).cast<Map<String, dynamic>>();

    return list.map(PokemonSet.fromJson).toList();
  }

  // ---------- PRIVÉ : LIRE LE CACHE ----------
  Future<List<PokemonSet>?> _loadSetsFromCache() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKeySets);

    if (jsonString == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(jsonString) as List<dynamic>;
      return decoded
          .cast<Map<String, dynamic>>()
          .map(PokemonSet.fromJson)
          .toList();
    } catch (e) {
      // Cache cassé -> on l'ignore
      return null;
    }
  }

  // ---------- PRIVÉ : ÉCRIRE LE CACHE ----------
  Future<void> _saveSetsToCache(List<PokemonSet> sets) async {
    final prefs = await SharedPreferences.getInstance();

    final listOfMaps = sets.map((s) => s.toJson()).toList();
    final jsonString = jsonEncode(listOfMaps);

    await prefs.setString(_cacheKeySets, jsonString);
  }
}
