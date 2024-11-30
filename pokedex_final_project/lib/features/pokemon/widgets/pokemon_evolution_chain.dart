import 'package:flutter/material.dart';
import '../../../core/models/pokemon_evolutions.dart';
import '../../../core/theme/pokemon_colors.dart';
import '../../../core/theme/trasantions/trasation_custom.dart';
import '../../../graphql/queries/pokemon_detail_by_id.dart';

class PokemonEvolutionChain extends StatelessWidget {
  final List<PokemonEvolution> evolutions;
  final Color backgroundColor;

  const PokemonEvolutionChain({
    super.key,
    required this.evolutions,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (evolutions.isEmpty) return const SizedBox.shrink();

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
      ),
      child: Column(
        children: [
          const Text(
            'EVOLUCIONES',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildEvolutionLayout(context),
        ],
      ),
    );
  }

  Widget _buildEvolutionLayout(BuildContext context) {
    // Si hay más de 3 evoluciones, usamos un layout en grid
    if (evolutions.length > 3) {
      return LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: evolutions.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(
                    'Evolución ${index + 1}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: _buildEvolutionItem(context, evolutions[index], index),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    // Para 3 o menos evoluciones, usamos un layout horizontal con flechas
    return SizedBox(
      height: 220,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _buildHorizontalEvolutionChain(context),
      ),
    );
  }

  List<Widget> _buildHorizontalEvolutionChain(BuildContext context) {
    List<Widget> chain = [];

    for (int i = 0; i < evolutions.length; i++) {
      if (i > 0) {
        chain.add(
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white.withOpacity(0.8),
                  size: 24,
                ),
              ),
              Text(
                'Nivel ${i + 1}',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      }

      chain.add(
        Expanded(
          child: _buildEvolutionItem(context, evolutions[i], i),
        ),
      );
    }

    return chain;
  }

  Widget _buildEvolutionItem(BuildContext context, PokemonEvolution evolution, int index) {
    return InkWell(
      onTap: () => _navigateToPokemon(context, evolution.id),
      child: Card(
        elevation: 4,
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
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
                        return const Icon(
                          Icons.catching_pokemon,
                          size: 40,
                          color: Colors.grey,
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
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'N.º ${evolution.id.toString().padLeft(3, '0')}',
                style: const TextStyle(
                  color: Colors.amberAccent,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: evolution.types.map((type) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToPokemon(BuildContext context, int id) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final pokemon = await fetchPokemonDetails(id);

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
  }
}