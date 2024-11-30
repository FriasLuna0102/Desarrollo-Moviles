import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../graphql/queries/pokemon_detail_by_id.dart';
import '../../screens/pokemon_detail.dart';

class PokemonGridItem extends StatefulWidget {
  final dynamic pokemon;
  const PokemonGridItem({super.key, required this.pokemon});

  @override
  State<PokemonGridItem> createState() => _PokemonGridItemState();
}

class _PokemonGridItemState extends State<PokemonGridItem> {
  bool _isFavorite = false;
  late SharedPreferences _preferences;
  late final dynamic pokemon;

  @override
  void initState() {
    super.initState();
    _initPrefs();
    pokemon = widget.pokemon;
  }

  Future<void> _initPrefs() async {
    _preferences = await SharedPreferences.getInstance();
    final favorites = _preferences.getStringList('favorites') ?? [];
    setState(() {
      _isFavorite = favorites.contains(widget.pokemon['id'].toString());
    });
  }

  Future<void> _toggleFavorite() async {
    final favorites = _preferences.getStringList('favorites') ?? [];
    final pokemonId = widget.pokemon['id'].toString();

    if (_isFavorite) {
      favorites.remove(pokemonId);
    } else {
      favorites.add(pokemonId);
    }

    await _preferences.setStringList('favorites', favorites);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }


  @override
  Widget build(BuildContext context) {

    final number = pokemon['id'];
    final name = pokemon['name'];
    final types = (pokemon['pokemon_v2_pokemontypes'] as List)
        .map((type) => type['pokemon_v2_type']['name'])
        .toList();
    final spriteUrl = pokemon['pokemon_v2_pokemonsprites'][0]['sprites'];

    String formatPokemonNumber(int number) {
      return '#${number.toString().padLeft(3, '0')}';
    }

    List<Color> getTypeColors(String type) {
      final typeColors = {
        'fire': [Colors.red, Colors.orange],
        'water': [Colors.blue, Colors.lightBlue],
        'grass': [Colors.green, Colors.lightGreen],
        'electric': [Colors.yellow, Colors.amber],
        'normal': [Colors.grey, Colors.blueGrey],
        'bug': [Colors.green, Colors.lime],
        'poison': [Colors.purple, Colors.deepPurple],
        'ground': [Colors.brown, Colors.orange],
        'flying': [Colors.blue, Colors.indigo],
        'fighting': [Colors.red, Colors.brown],
        'psychic': [Colors.pink, Colors.purple],
        'rock': [Colors.brown, Colors.grey],
        'ghost': [Colors.purple, Colors.indigo],
        'dragon': [Colors.indigo, Colors.deepPurple],
        'dark': [Colors.brown, Colors.grey],
        'steel': [Colors.grey, Colors.blueGrey],
        'fairy': [Colors.pink, Colors.deepPurple],
      };
      return typeColors[type.toLowerCase()] ?? [Colors.grey, Colors.blueGrey];
    }

      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16.0),
            enableFeedback: true,
            onTap: () async {
              final detailedPokemon = await fetchPokemonDetails(number);
              // Navegación al detalle del Pokémon
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(pokemon: detailedPokemon),
                ));
            },
            onDoubleTap: _toggleFavorite,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: types.map((type) => getTypeColors(type)).expand((colors) => colors).toList(),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatPokemonNumber(number),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Center(
                            child: Center(
                              child: spriteUrl != null
                                  ? CachedNetworkImage(
                                imageUrl: spriteUrl,
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) => const Icon(
                                  Icons.broken_image,
                                  size: 96,
                                ),
                              )
                                  : const Icon(  // Este es el caso cuando spriteUrl es null
                                Icons.broken_image,
                                size: 96,
                                color: Colors.white,  // Para que sea visible sobre el fondo de colores
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                name.toString().toUpperCase(),
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 4,
                                children: types.map((type) => Chip(
                                  label: Text(
                                    type.toString().toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                  backgroundColor: getTypeColors(type.toString())[0],
                                  padding: EdgeInsets.zero,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                )).toList(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // Ícono de favorito con animación
                Positioned(
                  top: 8,
                  right: 8,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      key: ValueKey(_isFavorite),
                      color: _isFavorite ? Colors.red : Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
}
