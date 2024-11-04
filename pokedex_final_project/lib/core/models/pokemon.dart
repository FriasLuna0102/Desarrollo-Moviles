import 'dart:convert';
import 'package:pokedex_final_project/core/models/pokemon_ability.dart';
import 'package:pokedex_final_project/core/models/pokemon_evolutions.dart';
import 'package:pokedex_final_project/core/models/pokemon_move.dart';
import 'package:pokedex_final_project/core/models/pokemon_stat.dart';
import 'package:pokedex_final_project/core/models/pokemon_type.dart';
import 'package:pokedex_final_project/core/models/pokemon_type_relations.dart';

class Pokemon {
  final int id;
  final String name;
  final String? imageUrl;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final double weight;
  final double height;
  final List<PokemonEvolution> evolutions;
  final List<PokemonMove> moves;
  final PokemonTypeRelations typeRelations;
  final String genus;

  Pokemon({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.weight,
    required this.height,
    required this.evolutions,
    required this.moves,
    required this.typeRelations,
    required this.genus,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Manejo de sprites
    String? spriteUrl;
    try {
      final spritesJson = json['pokemon_v2_pokemonsprites']?[0]?['sprites'];
      if (spritesJson != null) {
        // Si spritesJson es un String, necesitamos parsearlo
        final Map<String, dynamic> spritesMap =
        spritesJson is String ? jsonDecode(spritesJson) : spritesJson;

        // Accedemos a la ruta 'other' -> 'home' -> 'front_default'
        spriteUrl = spritesMap['other']?['home']?['front_default'];
      }
    } catch (e) {
      spriteUrl = null;
    }

    final List<Map<String, dynamic>> typesForRelations =
        (json['pokemon_v2_pokemontypes'] as List?)
            ?.map((type) => Map<String, dynamic>.from(type))
            .toList() ?? [];

    List<PokemonEvolution> evolutionsList = [];
    try {
      final speciesData = json['pokemon_v2_pokemonspecy'];
      if (speciesData != null &&
          speciesData['pokemon_v2_evolutionchain'] != null &&
          speciesData['pokemon_v2_evolutionchain']['pokemon_v2_pokemonspecies'] != null) {

        final List<dynamic> species =
        speciesData['pokemon_v2_evolutionchain']['pokemon_v2_pokemonspecies'];

        evolutionsList = species.map((speciesJson) => PokemonEvolution(
          id: speciesJson['id'],
          name: speciesJson['name'],
        )).toList();
      }
    } catch (e) {
      print('Error parsing evolutions: $e');
    }



    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: spriteUrl,
      types: (json['pokemon_v2_pokemontypes'] as List?)
          ?.map((type) => PokemonType.fromJson(type))
          .toList() ?? [],
      stats: (json['pokemon_v2_pokemonstats'] as List?)
          ?.map((stat) => PokemonStat.fromJson(stat))
          .toList() ?? [],
      abilities: (json['pokemon_v2_pokemonabilities'] as List?)
          ?.map((ability) => PokemonAbility.fromJson(ability))
          .toList() ?? [],
      evolutions: evolutionsList,
      weight: (json['weight'] ?? 0) / 10,
      height: (json['height'] ?? 0) / 10,
      moves: (json['pokemon_v2_pokemonmoves'] as List?)
          ?.map((move) => PokemonMove.fromJson(move))
          .toList() ?? [],
      typeRelations: PokemonTypeRelations.fromTypes(typesForRelations),
      genus: json['pokemon_v2_pokemonspecy']['pokemon_v2_pokemonspeciesnames'][0]['genus'],
    );

  }
}