import 'package:flutter/material.dart';
import '../../../core/models/pokemon_type_relations.dart';
import '../../../core/theme/pokemon_colors.dart';

class PokemonTypeRelationsWidget extends StatelessWidget {
  final PokemonTypeRelations relations;
  final Color backgroundColor;

  const PokemonTypeRelationsWidget({
    super.key,
    required this.relations,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (relations.weaknesses.isNotEmpty) ...[
          const Text(
            'DEBILIDADES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTypeList(relations.weaknesses),
        ],
        if (relations.strengths.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'FORTALEZAS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTypeList(relations.strengths),
        ],
        if (relations.resistances.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'RESISTENCIAS',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTypeList(relations.resistances),
        ],
        if (relations.immunities.isNotEmpty) ...[
          const SizedBox(height: 16),
          const Text(
            'INMUNIDADES',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          _buildTypeList(relations.immunities),
        ],
      ],
    );
  }

  Widget _buildTypeList(List<TypeEfficacy> types) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: types.map((type) => _buildTypeChip(type)).toList(),
    );
  }

  Widget _buildTypeChip(TypeEfficacy type) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: PokemonColors.getTypeColor(type.type),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            type.type.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '×${type.damageFactor.toStringAsFixed(1)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}