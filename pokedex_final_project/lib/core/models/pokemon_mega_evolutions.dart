import 'package:pokedex_final_project/core/models/pokemon_type.dart';

class PokemonMegaEvolution {
  final int id;           // form_id
  final int pokemonId;    // ID del pokemon mega evolución
  final String formName;
  final String name;
  final List<PokemonType> types;
  final String? imageUrl;

  PokemonMegaEvolution({
    required this.id,
    required this.pokemonId,
    required this.formName,
    required this.name,
    required this.types,
    this.imageUrl,
  });

  factory PokemonMegaEvolution.fromJson(Map<String, dynamic> json) {
    List<PokemonType> types = [];
    if (json['pokemon_v2_pokemontypes'] != null) {
      types = (json['pokemon_v2_pokemontypes'] as List)
          .map((type) => PokemonType.fromJson(type['pokemon_v2_type']))
          .toList();
    }

    return PokemonMegaEvolution(
      id: json['id'],
      pokemonId: json['pokemon_id'],
      formName: json['form_name'] ?? '',
      name: json['name'] ?? '',
      types: types,
      imageUrl: 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${json['pokemon_id']}.png',
    );
  }
}
