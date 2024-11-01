import 'dart:math' as math;


class TypeEfficacy {
  final String type;
  final double damageFactor;

  TypeEfficacy({
    required this.type,
    required this.damageFactor,
  });

  factory TypeEfficacy.fromJson(Map<String, dynamic> json) {
    return TypeEfficacy(
      type: json['pokemon_v2_type']['name'],
      damageFactor: json['damage_factor'] / 100,
    );
  }
}

class PokemonTypeRelations {
  final List<TypeEfficacy> weaknesses;
  final List<TypeEfficacy> resistances;
  final List<TypeEfficacy> immunities;
  final List<TypeEfficacy> strengths;

  PokemonTypeRelations({
    required this.weaknesses,
    required this.resistances,
    required this.immunities,
    required this.strengths,
  });

  factory PokemonTypeRelations.fromTypes(List<Map<String, dynamic>> types) {
    Map<String, double> defenseEffectiveness = {};
    Map<String, double> attackEffectiveness = {};

    // Procesar cada tipo del Pokémon
    for (var typeData in types) {
      final pokemonType = typeData['pokemon_v2_type'];

      // Debilidades y resistencias
      final defensiveRelations = pokemonType['pokemonV2TypeefficaciesByTargetTypeId'] as List;
      for (var relation in defensiveRelations) {
        final attackingType = relation['pokemon_v2_type']['name'] as String;
        final factor = relation['damage_factor'] as int;

        if (defenseEffectiveness.containsKey(attackingType)) {
          defenseEffectiveness[attackingType] = defenseEffectiveness[attackingType]! * (factor / 100);
        } else {
          defenseEffectiveness[attackingType] = factor / 100;
        }
      }

      // Fortalezas
      final offensiveRelations = pokemonType['pokemon_v2_typeefficacies'] as List;
      for (var relation in offensiveRelations) {
        final defendingType = relation['pokemonV2TypeByTargetTypeId']['name'] as String;
        final factor = relation['damage_factor'] as int;

        if (attackEffectiveness.containsKey(defendingType)) {
          attackEffectiveness[defendingType] =
              math.max(attackEffectiveness[defendingType]!, factor / 100);
        } else {
          attackEffectiveness[defendingType] = factor / 100;
        }
      }
    }

    // Clasificar las efectividades
    List<TypeEfficacy> weaknesses = [];
    List<TypeEfficacy> resistances = [];
    List<TypeEfficacy> immunities = [];
    List<TypeEfficacy> strengths = [];

    defenseEffectiveness.forEach((type, factor) {
      final efficacy = TypeEfficacy(type: type, damageFactor: factor);
      if (factor > 1) {
        weaknesses.add(efficacy);
      } else if (factor < 1 && factor > 0) {
        resistances.add(efficacy);
      } else if (factor == 0) {
        immunities.add(efficacy);
      }
    });

    attackEffectiveness.forEach((type, factor) {
      if (factor > 1) {
        strengths.add(TypeEfficacy(type: type, damageFactor: factor));
      }
    });

    return PokemonTypeRelations(
      weaknesses: weaknesses..sort((a, b) => b.damageFactor.compareTo(a.damageFactor)),
      resistances: resistances..sort((a, b) => a.damageFactor.compareTo(b.damageFactor)),
      immunities: immunities,
      strengths: strengths..sort((a, b) => b.damageFactor.compareTo(a.damageFactor)),
    );
  }
}