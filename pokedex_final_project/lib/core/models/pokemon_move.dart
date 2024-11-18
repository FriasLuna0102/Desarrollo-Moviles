class PokemonMove {
  final String name;
  final int? power;
  final int? accuracy;
  final int pp;
  final String type;
  final int level;

  PokemonMove({
    required this.name,
    this.power,
    this.accuracy,
    required this.pp,
    required this.type,
    required this.level,
  });

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    final moveData = json['pokemon_v2_move'];
    return PokemonMove(
      name: moveData['name'],
      power: moveData['power'],
      accuracy: moveData['accuracy'],
      pp: moveData['pp'],
      type: moveData['pokemon_v2_type']['name'],
      level: json['level'],
    );
  }

  @override
  String toString() {
    return 'PokemonMove{name: $name, power: $power, accuracy: $accuracy, pp: $pp, type: $type, level: $level}';
  }
}