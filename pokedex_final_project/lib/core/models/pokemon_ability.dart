class PokemonAbility {
  final String name;

  PokemonAbility({required this.name});

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      name: json['pokemon_v2_ability']['name'],
    );
  }
}