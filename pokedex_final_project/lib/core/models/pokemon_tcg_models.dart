class PokemonCard {
  final String id;
  final String name;
  final String imageUrl;
  final String imageUrlHiRes;
  final String supertype;
  final String? hp;
  final List<String> types;
  final List<Attack> attacks;
  final List<Weakness> weaknesses;

  PokemonCard({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.imageUrlHiRes,
    required this.supertype,
    this.hp,
    required this.types,
    required this.attacks,
    required this.weaknesses,
  });

  factory PokemonCard.fromJson(Map<String, dynamic> json) {
    return PokemonCard(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['images']?['small'] ?? '',
      imageUrlHiRes: json['images']?['large'] ?? '',
      supertype: json['supertype'] ?? '',
      hp: json['hp'],
      types: List<String>.from(json['types'] ?? []),
      attacks: (json['attacks'] as List?)?.map((x) => Attack.fromJson(x)).toList() ?? [],
      weaknesses: (json['weaknesses'] as List?)?.map((x) => Weakness.fromJson(x)).toList() ?? [],
    );
  }
}

class Attack {
  final String name;
  final List<String> cost;
  final int? damage;
  final String? text;

  Attack({
    required this.name,
    required this.cost,
    this.damage,
    this.text,
  });

  factory Attack.fromJson(Map<String, dynamic> json) {
    return Attack(
      name: json['name'] ?? '',
      cost: List<String>.from(json['cost'] ?? []),
      damage: int.tryParse(json['damage']?.replaceAll(RegExp(r'[^0-9]'), '') ?? ''),
      text: json['text'],
    );
  }
}

class Weakness {
  final String type;
  final String value;

  Weakness({
    required this.type,
    required this.value,
  });

  factory Weakness.fromJson(Map<String, dynamic> json) {
    return Weakness(
      type: json['type'] ?? '',
      value: json['value'] ?? '',
    );
  }
}