import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/pokemon_tcg_models.dart';

class PokemonTCGService {
  static const String baseUrl = 'https://api.pokemontcg.io/v2';

  static Future<List<PokemonCard>> searchCardsByPokemonName(String pokemonName) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cards?q=name:"$pokemonName"'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['data'] as List)
            .map((card) => PokemonCard.fromJson(card))
            .toList();
      } else {
        throw Exception('Failed to load cards');
      }
    } catch (e) {
      print('Error fetching cards: $e');
      return [];
    }
  }
}