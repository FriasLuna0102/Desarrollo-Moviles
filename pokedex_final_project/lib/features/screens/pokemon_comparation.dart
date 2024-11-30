import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/models/pokemon.dart';
import '../../graphql/queries/pokemon_detail_by_id.dart';

class EnhancedPokemonComparison extends StatefulWidget {
  const EnhancedPokemonComparison({super.key});

  @override
  State<EnhancedPokemonComparison> createState() => _EnhancedPokemonComparisonState();
}

  class _EnhancedPokemonComparisonState extends State<EnhancedPokemonComparison> {
    Pokemon? pokemon1;
    Pokemon? pokemon2;
    bool isStatsExpanded = true;
    bool isTypeRelationsExpanded = true;
    bool isDetailsExpanded = true;
    bool isLoading = false;
    final TextEditingController _searchController1 = TextEditingController();
    final TextEditingController _searchController2 = TextEditingController();

    Widget _buildTypeChip(String type) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          type.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    Widget _buildExpandableSection({
      required String title,
      required bool isExpanded,
      required VoidCallback onToggle,
      required Widget child,
    }) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            InkWell(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade400, Colors.red.shade600],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded)
              Padding(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
          ],
        ),
      );
    }

    RadarDataSet _createRadarDataSet(List<double> values, Color color) {
      return RadarDataSet(
        fillColor: color.withOpacity(0.2),
        borderColor: color,
        entryRadius: 2,
        dataEntries: values.map((value) => RadarEntry(value: value)).toList(),
      );
    }

    Widget _buildTypeRelations() {
      if (pokemon1 == null || pokemon2 == null) return const SizedBox.shrink();

      final relations = [
        {
          'name': 'Weaknesses',
          'icon': Icons.warning,
          'pokemon1': pokemon1!.typeRelations.weaknesses.length,
          'pokemon2': pokemon2!.typeRelations.weaknesses.length
        },
        {
          'name': 'Resistances',
          'icon': Icons.shield,
          'pokemon1': pokemon1!.typeRelations.resistances.length,
          'pokemon2': pokemon2!.typeRelations.resistances.length
        },
        {
          'name': 'Immunities',
          'icon': Icons.security,
          'pokemon1': pokemon1!.typeRelations.immunities.length,
          'pokemon2': pokemon2!.typeRelations.immunities.length
        },
      ];

      return LayoutBuilder(
        builder: (context, constraints) {
          final itemWidth = (constraints.maxWidth - 32) / 3;
          return Wrap(
            spacing: 16,
            runSpacing: 16,
            children: relations.map((relation) {
              final value1 = relation['pokemon1'] as int;
              final value2 = relation['pokemon2'] as int;

              return SizedBox(
                width: itemWidth,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(relation['icon'] as IconData, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        relation['name'] as String,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '$value1 vs $value2',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: value1 != value2
                                ? value1 > value2 ? Colors.green : Colors.orange
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      );
    }




    Widget _buildDetailedComparison() {
      if (pokemon1 == null || pokemon2 == null) return const SizedBox.shrink();

      final details = [
        {
          'name': 'Height',
          'pokemon1': '${pokemon1!.height}m',
          'pokemon2': '${pokemon2!.height}m'
        },
        {
          'name': 'Weight',
          'pokemon1': '${pokemon1!.weight}kg',
          'pokemon2': '${pokemon2!.weight}kg'
        },
        {
          'name': 'Moves',
          'pokemon1': pokemon1!.moves.length.toString(),
          'pokemon2': pokemon2!.moves.length.toString()
        },
        {
          'name': 'Category',
          'pokemon1': pokemon1!.genus,
          'pokemon2': pokemon2!.genus
        },
      ];

      return Column(
        children: details.map((detail) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade200,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    detail['name'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          detail['pokemon1'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                        const Text(
                          ' vs ',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          detail['pokemon2'] as String,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )).toList(),
      );
    }


    Future<void> _searchPokemon(String value, bool isFirstPokemon) async {
      if (value.isEmpty) return;

      setState(() {
        isLoading = true;
      });

      try {
        int pokemonId = int.tryParse(value) ?? 1;
        final pokemon = await fetchPokemonDetails(pokemonId);

        setState(() {
          if (isFirstPokemon) {
            pokemon1 = pokemon;
          } else {
            pokemon2 = pokemon;
          }
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al buscar el Pokémon: $e')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Comparar Pokémon',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildSearchSection(),
                    const SizedBox(height: 16),
                    _buildHeaderComparison(),
                    if (pokemon1 != null && pokemon2 != null) ...[
                      const SizedBox(height: 16),
                      _buildExpandableSection(
                        title: 'Base Stats Comparison',
                        isExpanded: isStatsExpanded,
                        onToggle: () => setState(() => isStatsExpanded = !isStatsExpanded),
                        child: _buildStatsComparison(),
                      ),
                      const SizedBox(height: 16),
                      _buildExpandableSection(
                        title: 'Type Relations',
                        isExpanded: isTypeRelationsExpanded,
                        onToggle: () => setState(() => isTypeRelationsExpanded = !isTypeRelationsExpanded),
                        child: _buildTypeRelations(),
                      ),
                      const SizedBox(height: 16),
                      _buildExpandableSection(
                        title: 'Additional Details',
                        isExpanded: isDetailsExpanded,
                        onToggle: () => setState(() => isDetailsExpanded = !isDetailsExpanded),
                        child: _buildDetailedComparison(),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      );
    }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController1,
            decoration: InputDecoration(
              labelText: 'ID del primer Pokémon',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchPokemon(_searchController1.text, true),
              ),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _searchPokemon(value, true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _searchController2,
            decoration: InputDecoration(
              labelText: 'ID del segundo Pokémon',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _searchPokemon(_searchController2.text, false),
              ),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _searchPokemon(value, false),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderComparison() {
    if (pokemon1 == null && pokemon2 == null) {
      return const Center(
        child: Text(
          'Ingresa los IDs de los Pokémon para compararlos',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _buildPokemonHeader(pokemon1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.shade400,
              shape: BoxShape.circle,
            ),
            child: const Text(
              'VS',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: _buildPokemonHeader(pokemon2),
        ),
      ],
    );
  }

  Widget _buildPokemonHeader(Pokemon? pokemon) {
    if (pokemon == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            'Selecciona un Pokémon',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    Color typeColor = _getTypeColor(pokemon.types.first.name);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            typeColor.withOpacity(0.7),
            typeColor.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          if (pokemon.imageUrl != null)
            Image.network(
              pokemon.imageUrl!,
              height: 100,
              width: 100,
              fit: BoxFit.contain,
            ),
          Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: pokemon.types.map((type) => _buildTypeChip(type.name)).toList(),
          ),
        ],
      ),
    );
  }


  Color _getTypeColor(String type) {
    final Map<String, Color> typeColors = {
      'normal': Colors.grey,
      'fire': Colors.orange,
      'water': Colors.blue,
      'electric': Colors.yellow,
      'grass': Colors.green,
      'ice': Colors.cyan,
      'fighting': Colors.red,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo,
      'psychic': Colors.pink,
      'bug': Colors.lightGreen,
      'rock': Colors.grey.shade700,
      'ghost': Colors.deepPurple,
      'dragon': Colors.indigo,
      'dark': Colors.grey.shade900,
      'steel': Colors.blueGrey,
      'fairy': Colors.pinkAccent,
    };
    return typeColors[type.toLowerCase()] ?? Colors.grey;
  }

  Widget _buildStatsComparison() {
    if (pokemon1 == null || pokemon2 == null) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: RadarChart(
            RadarChartData(
              radarShape: RadarShape.polygon,
              ticksTextStyle: const TextStyle(color: Colors.transparent),
              tickBorderData: const BorderSide(color: Colors.transparent),
              gridBorderData: BorderSide(color: Colors.grey.shade300),
              titleTextStyle: const TextStyle(fontSize: 12),
              dataSets: [
                _createRadarDataSet(
                  pokemon1!.stats.map((stat) => stat.baseStat.toDouble()).toList(),
                  _getTypeColor(pokemon1!.types.first.name),
                ),
                _createRadarDataSet(
                  pokemon2!.stats.map((stat) => stat.baseStat.toDouble()).toList(),
                  _getTypeColor(pokemon2!.types.first.name),
                ),
              ],
              radarBorderData: BorderSide(color: Colors.grey.shade300),
              titlePositionPercentageOffset: 0.2,
              getTitle: (index, angle) {
                final stats = ['HP', 'Attack', 'Defense', 'Sp.Atk', 'Sp.Def', 'Speed'];
                return RadarChartTitle(
                  text: stats[index],
                  angle: angle,
                );
              },
              tickCount: 6,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildStatsLegend(),
      ],
    );
  }

  Widget _buildStatsLegend() {
    if (pokemon1 == null || pokemon2 == null) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: pokemon1!.stats.length,
      itemBuilder: (context, index) {
        final stat1 = pokemon1!.stats[index];
        final stat2 = pokemon2!.stats[index];

        return Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(_getStatIcon(stat1.name), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  stat1.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                '${stat1.baseStat}',
                style: TextStyle(
                  color: stat1.baseStat > stat2.baseStat ? Colors.green : Colors.black,
                  fontWeight: stat1.baseStat > stat2.baseStat ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              const Text(' vs '),
              Text(
                '${stat2.baseStat}',
                style: TextStyle(
                  color: stat2.baseStat > stat1.baseStat ? Colors.orange : Colors.black,
                  fontWeight: stat2.baseStat > stat1.baseStat ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getStatIcon(String statName) {
    switch (statName.toLowerCase()) {
      case 'hp':
        return Icons.favorite;
      case 'attack':
        return Icons.flash_on;
      case 'defense':
        return Icons.shield;
      case 'special-attack':
        return Icons.auto_awesome;
      case 'special-defense':
        return Icons.security;
      case 'speed':
        return Icons.speed;
      default:
        return Icons.star;
    }
  }

  

}

