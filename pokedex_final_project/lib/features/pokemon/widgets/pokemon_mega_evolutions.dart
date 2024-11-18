import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex_final_project/core/theme/trasantions/trasation_custom.dart';

import '../../../core/models/pokemon.dart';
import '../../../core/models/pokemon_mega_evolutions.dart';
import '../../../core/theme/pokemon_colors.dart';
import '../../../graphql/queries/pokemon_detail_by_id.dart';

class PokemonMegaEvolutionSection extends StatelessWidget {
  final List<PokemonMegaEvolution> megaEvolutions;
  final Color backgroundColor;
  final Pokemon pokemon;

  const PokemonMegaEvolutionSection({
    super.key,
    required this.megaEvolutions,
    required this.backgroundColor,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor.withOpacity(0.7),
            backgroundColor.withOpacity(0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'MEGA EVOLUCIONES',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildMegaEvolutionChain(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMegaEvolutionChain(BuildContext context) {
    List<Widget> megaEvolutionWidgets = [];

    for (int i = 0; i < megaEvolutions.length; i++) {
      megaEvolutionWidgets.add(
        Expanded(
          child: _buildMegaEvolutionItem(context, megaEvolutions[i], pokemon),
        ),
      );

      // Añadir el separador si no es el último Pokémon
      if (i < megaEvolutions.length - 1) {
        megaEvolutionWidgets.add(
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: 2,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.8),
                  Colors.white.withOpacity(0.2),
                ],
              ),
            ),
          ),
        );
      }
    }

    return megaEvolutionWidgets;
  }

  Widget _buildMegaEvolutionItem(BuildContext context, PokemonMegaEvolution megaEvolution, Pokemon pokemon) {
    return InkWell(
      onTap: () async {
        try {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(child: CircularProgressIndicator());
            },
          );

          // Usar pokemonId en lugar de id
          final pokemon = await fetchPokemonDetails(megaEvolution.pokemonId);

          if (context.mounted) {
            Navigator.pop(context);
            context.goToPokemonDetail(pokemon);
          }
        } catch (e) {
          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al cargar los detalles: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey[300]!,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
              ),
              if (megaEvolution.imageUrl != null)
                ClipOval(
                  child: Image.network(
                    megaEvolution.imageUrl!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.catching_pokemon,
                          size: 40,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            megaEvolution.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          Text(
            'N.º ${megaEvolution.pokemonId.toString().padLeft(4, '0')}',
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: pokemon.types.map((type) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: PokemonColors.getTypeColor(type.name),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    type.name.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}