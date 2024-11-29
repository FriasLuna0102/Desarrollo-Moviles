import 'package:flutter/material.dart';
import '../../../core/models/pokemon_stat.dart';

class PokemonStatBar extends StatelessWidget {
  final PokemonStat stat;

  const PokemonStatBar({super.key, required this.stat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stat.name.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                stat.baseStat.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: stat.baseStat / 255,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              stat.baseStat > 50 ? Colors.green : Colors.orange,
            ),
            minHeight: 8,
          ),
        ],
      ),
    );
  }
}