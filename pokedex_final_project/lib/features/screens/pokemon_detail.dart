// lib/features/pokemon/screens/pokemon_detail_screen.dart

import 'package:flutter/material.dart';
import '../../core/models/pokemon.dart';
import '../../core/theme/pokemon_colors.dart';
import '../pokemon/widgets/pokemon_metric_card.dart';
import '../pokemon/widgets/pokemon_stat_bar.dart';
import '../pokemon/widgets/pokemon_type_chip.dart';

import '../../core/models/pokemon_stat.dart';
import '../../core/models/pokemon_type.dart';
import '../../core/models/pokemon_ability.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            _buildHeaderCard(),
            const SizedBox(height: 16),
            _buildStatsSection(),
            const SizedBox(height: 16),
            _buildAbilitiesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            PokemonColors.getTypeColor(widget.pokemon.types.first.name).withOpacity(0.7),
            PokemonColors.getTypeColor(widget.pokemon.types.first.name).withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildPokemonHeader(),
          const SizedBox(height: 16),
          if (widget.pokemon.imageUrl != null)
            Image.network(
              widget.pokemon.imageUrl!,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          _buildPokemonName(),
          const SizedBox(height: 30),
          _buildPokemonTypes(),
          const SizedBox(height: 16),
          _buildPokemonMetrics(),
        ],
      ),
    );
  }

  Widget _buildPokemonHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Center(
            child: Text(
              'PC${widget.pokemon.id}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        IconButton(
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              isFavorite ? Icons.star : Icons.star_border,
              key: ValueKey<bool>(isFavorite),
              color: Colors.white,
              size: 28,
            ),
          ),
          onPressed: () {
            setState(() {
              isFavorite = !isFavorite;
            });
          },
        ),
      ],
    );
  }

  Widget _buildPokemonName() {
    return Text(
      widget.pokemon.name.toUpperCase(),
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildPokemonTypes() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Wrap(
          spacing: 8,
          children: widget.pokemon.types
              .map((type) => PokemonTypeChip(type: type))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPokemonMetrics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        PokemonMetricCard(
          value: '${widget.pokemon.weight}kg',
          label: 'PESO',
        ),
        PokemonMetricCard(
          value: '${widget.pokemon.height}m',
          label: 'ALTURA',
        ),
        PokemonMetricCard(
          value: '${widget.pokemon.height}m',  // Esto parece ser un error en tu código original
          label: 'ALTURA',
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'ESTADÍSTICAS',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...widget.pokemon.stats.map((stat) => PokemonStatBar(stat: stat)),
        ],
      ),
    );
  }

  Widget _buildAbilitiesSection() {
    return Column(
      children: [
        const Text(
          'HABILIDADES',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.pokemon.abilities.map((ability) => Chip(
            backgroundColor: PokemonColors.getTypeColor(
              widget.pokemon.types.first.name,
            ),
            label: Text(
              ability.name.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          )).toList(),
        ),
      ],
    );
  }
}