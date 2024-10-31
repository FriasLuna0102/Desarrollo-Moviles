class PokemonStat {
  final String name;
  final int baseStat;

  PokemonStat({required this.name, required this.baseStat});

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      name: json['pokemon_v2_stat']['name'],
      baseStat: json['base_stat'],
    );
  }
}
