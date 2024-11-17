// pokemon_evolutions.dart
import 'package:pokedex_final_project/core/models/pokemon_type.dart';

class PokemonEvolution {
  final int id;
  final String name;
  final List<PokemonType> types;

  PokemonEvolution({
    required this.id,
    required this.name,
    required this.types,
  });

  @override
  String toString() => 'PokemonEvolution(id: $id, name: $name, types: $types)';
}