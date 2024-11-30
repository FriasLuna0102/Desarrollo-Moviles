import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/models/pokemon.dart';
import '../../../core/theme/pokemon_colors.dart';
import '../../../graphql/queries/pokemon_detail_by_id.dart';

class PokemonComparisonScreen extends StatefulWidget {
  const PokemonComparisonScreen({super.key});

  @override
  State<PokemonComparisonScreen> createState() => _PokemonComparisonScreenState();
}

class _PokemonComparisonScreenState extends State<PokemonComparisonScreen> {
  Pokemon? pokemon1;
  Pokemon? pokemon2;
  final TextEditingController _searchController1 = TextEditingController();
  final TextEditingController _searchController2 = TextEditingController();

  Future<void> _searchPokemon(String value, bool isFirstPokemon) async {
    if (value.isEmpty) return;

    try {
      int pokemonId = int.tryParse(value) ?? 1;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(child: CircularProgressIndicator());
        },
      );

      final pokemon = await fetchPokemonDetails(pokemonId);

      if (mounted) {
        Navigator.pop(context);
        setState(() {
          if (isFirstPokemon) {
            pokemon1 = pokemon;
          } else {
            pokemon2 = pokemon;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchSection(),
              const SizedBox(height: 20),
              _buildPokemonHeaders(),
              const SizedBox(height: 20),
              _buildStatsComparison(),
              const SizedBox(height: 20),
              _buildTypeRelationsComparison(),
              const SizedBox(height: 20),
              _buildDetailedComparison(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController1,
            decoration: const InputDecoration(
              labelText: 'ID del primer Pokémon',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _searchPokemon(value, true),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: _searchController2,
            decoration: const InputDecoration(
              labelText: 'ID del segundo Pokémon',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            onSubmitted: (value) => _searchPokemon(value, false),
          ),
        ),
      ],
    );
  }

  Widget _buildPokemonHeaders() {
    return Row(
      children: [
        Expanded(child: _buildPokemonHeader(pokemon1, true)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'VS',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
        Expanded(child: _buildPokemonHeader(pokemon2, false)),
      ],
    );
  }

  Widget _buildPokemonHeader(Pokemon? pokemon, bool isFirst) {
    if (pokemon == null) {
      return Container(
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text('Selecciona un Pokémon'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            PokemonColors.getTypeColor(pokemon.types.first.name).withOpacity(0.7),
            PokemonColors.getTypeColor(pokemon.types.first.name).withOpacity(0.3),
          ],
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
            ),
          Text(
            pokemon.name.toUpperCase(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 4,
            children: pokemon.types.map((type) {
              return Chip(
                backgroundColor: PokemonColors.getTypeColor(type.name),
                label: Text(
                  type.name.toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Comparación de Stats',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: pokemon1 != null && pokemon2 != null
                  ? RadarChart(
                RadarChartData(
                  radarShape: RadarShape.polygon,
                  tickCount: 5,
                  dataSets: [
                    _createRadarDataSet(pokemon1!, Colors.red),
                    _createRadarDataSet(pokemon2!, Colors.blue),
                  ],
                ),
              )
                  : const Center(child: Text('Selecciona dos Pokémon para comparar')),
            ),
          ],
        ),
      ),
    );
  }

  RadarDataSet _createRadarDataSet(Pokemon pokemon, Color color) {
    return RadarDataSet(
      fillColor: color.withOpacity(0.2),
      borderColor: color,
      entryRadius: 2,
      dataEntries: [
        RadarEntry(value: pokemon.stats[0].baseStat.toDouble()), // HP
        RadarEntry(value: pokemon.stats[1].baseStat.toDouble()), // Ataque
        RadarEntry(value: pokemon.stats[2].baseStat.toDouble()), // Defensa
        RadarEntry(value: pokemon.stats[3].baseStat.toDouble()), // Atq. Esp.
        RadarEntry(value: pokemon.stats[4].baseStat.toDouble()), // Def. Esp.
        RadarEntry(value: pokemon.stats[5].baseStat.toDouble()), // Velocidad
      ],
    );
  }

  Widget _buildTypeRelationsComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Relaciones de Tipo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (pokemon1 != null && pokemon2 != null)
              Table(
                border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Relación'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pokémon 1'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pokémon 2'),
                      ),
                    ],
                  ),
                  _buildTypeRelationRow('Debilidades',
                    pokemon1!.typeRelations.weaknesses.length,
                    pokemon2!.typeRelations.weaknesses.length,
                  ),
                  _buildTypeRelationRow('Resistencias',
                    pokemon1!.typeRelations.resistances.length,
                    pokemon2!.typeRelations.resistances.length,
                  ),
                  _buildTypeRelationRow('Inmunidades',
                    pokemon1!.typeRelations.immunities.length,
                    pokemon2!.typeRelations.immunities.length,
                  ),
                ],
              )
            else
              const Text('Selecciona dos Pokémon para comparar'),
          ],
        ),
      ),
    );
  }

  TableRow _buildTypeRelationRow(String label, int value1, int value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value1.toString()),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value2.toString()),
        ),
      ],
    );
  }

  Widget _buildDetailedComparison() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Comparación Detallada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (pokemon1 != null && pokemon2 != null)
              Table(
                border: TableBorder.all(),
                children: [
                  const TableRow(
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Característica'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pokémon 1'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Pokémon 2'),
                      ),
                    ],
                  ),
                  _buildDetailRow('Altura', '${pokemon1!.height} m', '${pokemon2!.height} m'),
                  _buildDetailRow('Peso', '${pokemon1!.weight} kg', '${pokemon2!.weight} kg'),
                  _buildDetailRow('Movimientos', pokemon1!.moves.length.toString(), pokemon2!.moves.length.toString()),
                  _buildDetailRow('Categoría', pokemon1!.genus, pokemon2!.genus),
                ],
              )
            else
              const Text('Selecciona dos Pokémon para comparar'),
          ],
        ),
      ),
    );
  }

  TableRow _buildDetailRow(String label, String value1, String value2) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(label),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value1),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value2),
        ),
      ],
    );
  }
}