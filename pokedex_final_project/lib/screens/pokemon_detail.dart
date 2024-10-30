import 'package:flutter/material.dart';
import 'dart:convert';

class PokemonDetail extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  Color getTypeColor(String type) {
    final typeColors = {
      'normal': Colors.grey[400]!,
      'fire': Colors.orange,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'ice': Colors.cyan,
      'fighting': Colors.red[800]!,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo[200]!,
      'psychic': Colors.pink,
      'bug': Colors.lightGreen,
      'rock': Colors.brown[300]!,
      'ghost': Colors.deepPurple,
      'dark': Colors.grey[800]!,
      'dragon': Colors.indigo,
      'steel': Colors.blueGrey,
      'fairy': Colors.pinkAccent,
    };
    return typeColors[type] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    final spritesJson = pokemon['pokemon_v2_pokemonsprites'] != null
        ? pokemon['pokemon_v2_pokemonsprites'][0]['sprites']
        : null;

    final imageUrl = spritesJson?['front_default'];
    final types = pokemon['pokemon_v2_pokemontypes'] ?? [];
    final stats = pokemon['pokemon_v2_pokemonstats'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          pokemon['name'].toString().toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // PC and Image
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'PC${pokemon['id']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Icon(Icons.camera_alt_outlined),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (imageUrl != null)
                    Image.network(
                      imageUrl,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),

                  // Types
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (var type in types)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Chip(
                            backgroundColor: getTypeColor(
                              type['pokemon_v2_type']['name'],
                            ),
                            label: Text(
                              type['pokemon_v2_type']['name'].toString().toUpperCase(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Stats
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${pokemon['weight'] / 10}kg',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('PESO'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${pokemon['height'] / 10}m',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('ALTURA'),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '${pokemon['height'] / 10}m',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('ALTURA'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ESTADÍSTICAS',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  for (var stat in stats)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stat['pokemon_v2_stat']['name'].toString().toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: stat['base_stat'] / 255,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              stat['base_stat'] > 50 ? Colors.green : Colors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}