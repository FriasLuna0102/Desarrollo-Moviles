import 'package:flutter/material.dart';
import 'package:pokedex_final_project/core/models/pokemon_ability.dart';
import 'package:pokedex_final_project/core/models/pokemon_stat.dart';
import 'package:pokedex_final_project/core/models/pokemon_type.dart';


class Pokemon {
  final int id;
  final String name;
  final String? imageUrl;
  final List<PokemonType> types;
  final List<PokemonStat> stats;
  final List<PokemonAbility> abilities;
  final double weight;
  final double height;

  Pokemon({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.types,
    required this.stats,
    required this.abilities,
    required this.weight,
    required this.height,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final spritesJson = json['pokemon_v2_pokemonsprites']?[0]?['sprites'];

    return Pokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: spritesJson?['front_default'],
      types: (json['pokemon_v2_pokemontypes'] as List?)
          ?.map((type) => PokemonType.fromJson(type))
          .toList() ?? [],
      stats: (json['pokemon_v2_pokemonstats'] as List?)
          ?.map((stat) => PokemonStat.fromJson(stat))
          .toList() ?? [],
      abilities: (json['pokemon_v2_pokemonabilities'] as List?)
          ?.map((ability) => PokemonAbility.fromJson(ability))
          .toList() ?? [],
      weight: (json['weight'] ?? 0) / 10,
      height: (json['height'] ?? 0) / 10,
    );
  }
}
