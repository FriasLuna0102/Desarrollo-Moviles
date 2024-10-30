import 'package:flutter/material.dart';
import 'dart:convert';

class PokemonDetail extends StatefulWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  State<PokemonDetail> createState() => _PokemonDetailState();
}

class _PokemonDetailState extends State<PokemonDetail> {
  bool isFavorite = false;

  Color getTypeColor(String type) {
    final typeColors = {
      'normal': Colors.grey[700]!,
      'fire': Colors.orange,
      'water': Colors.blue,
      'grass': Colors.green,
      'electric': Colors.yellow,
      'ice': Colors.cyan,
      'fighting': Colors.red[800]!,
      'poison': Colors.purple,
      'ground': Colors.brown,
      'flying': Colors.indigo[400]!,
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
    final spritesJson = widget.pokemon['pokemon_v2_pokemonsprites'] != null
        ? widget.pokemon['pokemon_v2_pokemonsprites'][0]['sprites']
        : null;

    final imageUrl = spritesJson?['front_default'];
    final types = widget.pokemon['pokemon_v2_pokemontypes'] ?? [];
    final stats = widget.pokemon['pokemon_v2_pokemonstats'] ?? [];
    final pokemonAbilities = widget.pokemon['pokemon_v2_pokemonabilities'] ?? [];

    final primaryType = types.isNotEmpty ? types[0]['pokemon_v2_type']['name'] : 'normal';
    final primaryColor = getTypeColor(primaryType);

    return Scaffold(
      backgroundColor: Colors.grey[100],
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
                            'PC${widget.pokemon['id']}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                key: ValueKey<bool>(isFavorite),
                                color: isFavorite ? Colors.amber : Colors.grey,
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
                      ),
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



                  Text(
                    widget.pokemon['name'].toString().toUpperCase(),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 30),
                  // Types and Favorite Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
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
                            '${widget.pokemon['weight'] / 10}kg',
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
                            '${widget.pokemon['height'] / 10}m',
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
                            '${widget.pokemon['height'] / 10}m',
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
            const SizedBox(height: 16),
            const Text(
              'HABILIDADES',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Recuadros de habilidades

          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var ability in pokemonAbilities)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Chip(
                    backgroundColor: getTypeColor(
                      primaryType,
                    ),
                    label: Text(
                      ability['pokemon_v2_ability']['name'].toString().toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
      ],
        ),
      ),
    );
  }
}