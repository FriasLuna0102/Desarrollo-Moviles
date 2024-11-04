// lib/features/pokemon/screens/pokemon_detail_screen.dart

import 'package:flutter/material.dart';
import 'package:pokedex_final_project/core/theme/trasantions/trasation_custom.dart';
import 'package:pokedex_final_project/features/screens/pokemon_list.dart';
import '../../core/models/pokemon.dart';
import '../../core/models/pokemon_evolutions.dart';
import '../../core/theme/pokemon_colors.dart';
import '../../graphql/queries/pokemon_detail_by_id.dart';
import '../pokemon/widgets/pokemon_metric_card.dart';
import '../pokemon/widgets/pokemon_moves_widget.dart';
import '../pokemon/widgets/pokemon_stat_bar.dart';
import '../pokemon/widgets/pokemon_type_chip.dart';
import '../pokemon/widgets/pokemon_type_relations_widget.dart';


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
            _buildTypeRelationsSection(),
            const SizedBox(height: 16),
            _buildAbilitiesSection(),
            const SizedBox(height: 16),
            _buildEvolutionSection(),
            const SizedBox(height: 16),
            _buildMovesSection(),
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
        // Botón de retroceso
        IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => context.goToPokemonList(),

        ),
        // ID del Pokémon
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
        // Botón de favorito
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
          value: '${widget.pokemon.genus}m',

          label: 'Categoria',
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



  Widget _buildEvolutionSection() {
    if (widget.pokemon.evolutions.isEmpty) {
      return const SizedBox.shrink();
    }

    // Obtenemos los colores de los tipos del Pokémon
    List<Color> gradientColors = widget.pokemon.types.length > 1
        ? [
      PokemonColors.getTypeColor(widget.pokemon.types[0].name),
      PokemonColors.getTypeColor(widget.pokemon.types[1].name),
    ]
        : [
      PokemonColors.getTypeColor(widget.pokemon.types[0].name).withOpacity(0.7),
      PokemonColors.getTypeColor(widget.pokemon.types[0].name).withOpacity(0.3),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
              padding: EdgeInsets.only(left: 16, bottom: 0),
              child: Center(
                child: Text(
                  'Evoluciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              )
          ),
          SizedBox(
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _buildEvolutionChain(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMovesSection() {
    if (widget.pokemon.moves.isEmpty) {
      return const SizedBox.shrink();
    }

    List<Color> gradientColors = widget.pokemon.types.length > 1
        ? [
      PokemonColors.getTypeColor(widget.pokemon.types[0].name),
      PokemonColors.getTypeColor(widget.pokemon.types[1].name),
    ]
        : [
      PokemonColors.getTypeColor(widget.pokemon.types[0].name).withOpacity(0.7),
      PokemonColors.getTypeColor(widget.pokemon.types[0].name).withOpacity(0.3),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, bottom: 16),

          ),
          PokemonMovesWidget(
            moves: widget.pokemon.moves,
            backgroundColor: PokemonColors.getTypeColor(widget.pokemon.types.first.name),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildEvolutionChain() {
    List<Widget> evolutionWidgets = [];

    for (int i = 0; i < widget.pokemon.evolutions.length; i++) {

      evolutionWidgets.add(
        Expanded(
          child: _buildEvolutionItem(widget.pokemon.evolutions[i], i + 1),
        ),
      );

      // Añadir la flecha si no es el último Pokémon
      if (i < widget.pokemon.evolutions.length - 1) {
        evolutionWidgets.add(
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20,
            ),
          ),
        );
      }
    }

    return evolutionWidgets;
  }

  Widget _buildEvolutionItem(PokemonEvolution evolution, int number) {
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

          final pokemon = await fetchPokemonDetails(evolution.id);

          if (context.mounted) {
            Navigator.pop(context); // Cerrar el loading
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
          // Círculo con la imagen del Pokémon
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
              ClipOval(
                child: Image.network(
                  'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${evolution.id}.png',
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
            evolution.name.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
          Text(
            'N.º ${evolution.id.toString().padLeft(4, '0')}',
            style: const TextStyle(
              color: Colors.amberAccent,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const SizedBox(height: 4),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: widget.pokemon.types.map((type) {
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

  Widget _buildTypeRelationsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PokemonColors.getTypeColor(widget.pokemon.types.first.name).withOpacity(0.7),
            PokemonColors.getTypeColor(widget.pokemon.types.first.name).withOpacity(0.3),
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
              'RELACIONES DE TIPO',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 16),
          PokemonTypeRelationsWidget(
            relations: widget.pokemon.typeRelations,
            backgroundColor: PokemonColors.getTypeColor(widget.pokemon.types.first.name),
          ),
        ],
      ),
    );
  }

}

