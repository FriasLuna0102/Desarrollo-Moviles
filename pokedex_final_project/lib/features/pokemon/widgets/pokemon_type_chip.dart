import 'package:flutter/material.dart';

import '../../../core/models/pokemon_type.dart';
import '../../../core/theme/pokemon_colors.dart';


class PokemonTypeChip extends StatelessWidget {
  final PokemonType type;

  const PokemonTypeChip({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: PokemonColors.getTypeColor(type.name),
      label: Text(
        type.name.toUpperCase(),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}