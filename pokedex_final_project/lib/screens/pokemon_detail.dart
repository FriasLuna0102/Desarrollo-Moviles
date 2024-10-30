// pokemon_detail.dart
import 'package:flutter/material.dart';

class PokemonDetail extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetail({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {

    final spritesJson = pokemon['pokemon_v2_pokemonsprites'] != null
        ? pokemon['pokemon_v2_pokemonsprites'][0]['sprites']
        : null;

    // Decodifica el JSON si existe

    final imageUrl = spritesJson?['front_default'];
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "ID: ${pokemon['id']}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            imageUrl != null
                ? Image.network(
              imageUrl,
              width: 100,
              height: 100,
            )
                : const Icon(Icons.image_not_supported, size: 100), // Muestra un ícono si no hay imagen
            const SizedBox(height: 8),
            Text(
              "Height: ${pokemon['height']}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Weight: ${pokemon['weight']}",
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
