class PokemonEvolution {
  final int id;
  final String name;

  PokemonEvolution({
    required this.id,
    required this.name,
  });

  @override
  String toString() => 'PokemonEvolution(id: $id, name: $name)';
}