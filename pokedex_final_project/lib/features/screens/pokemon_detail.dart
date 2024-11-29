import 'package:flutter/material.dart';
import 'package:pokedex_final_project/core/theme/trasantions/trasation_custom.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/models/pokemon.dart';
import '../../core/models/pokemon_evolutions.dart';
import '../../core/theme/pokemon_colors.dart';
import '../../graphql/queries/pokemon_detail_by_id.dart';
import '../pokemon/widgets/pokemon_mega_evolutions.dart';
import '../pokemon/widgets/pokemon_metric_card.dart';
import '../pokemon/widgets/pokemon_moves_widget.dart';
import '../pokemon/widgets/pokemon_stat_bar.dart';
import '../pokemon/widgets/pokemon_type_chip.dart';
import '../pokemon/widgets/pokemon_type_relations_widget.dart';
import 'dart:math' show pi;

import 'home_page.dart';


class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailScreen({super.key, required this.pokemon});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> with TickerProviderStateMixin {

  bool isFavorite = false;
  double _rotationValue = 0.0;
  double _lastRotation = 0.0;
  bool _isDragging = false;
  late AnimationController _autoRotationController;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
    _autoRotationController = AnimationController(
      duration: const Duration(milliseconds: 100000),
      vsync: this,
    );

    _autoRotationController.addListener(() {
      setState(() {
        _rotationValue = _lastRotation + (2 * pi * CurvedAnimation(
          parent: _autoRotationController,
          curve: Curves.easeInOutQuad,
        ).value);
      });
    });
  }

  @override
  void dispose() {
    _autoRotationController.dispose();
    super.dispose();
  }

  Future<void> _loadFavoriteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? favorites = prefs.getStringList('favorites');
    if (mounted) {
      setState(() {
        isFavorite = favorites?.contains(widget.pokemon.id.toString()) ?? false;
      });
    }
  }

  Future<void> _toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList('favorites') ?? [];
    final String pokemonId = widget.pokemon.id.toString();

    setState(() {
      if (favorites.contains(pokemonId)) {
        favorites.remove(pokemonId);
        isFavorite = false;
      } else {
        favorites.add(pokemonId);
        isFavorite = true;
      }
    });

    await prefs.setStringList('favorites', favorites);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              isFavorite
                  ? '${widget.pokemon.name.toUpperCase()} agregado a favoritos'
                  : '${widget.pokemon.name.toUpperCase()} eliminado de favoritos'
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'DESHACER',
            onPressed: _toggleFavorite,
          ),
        ),
      );
    }
  }


  Widget _buildMegaEvolutionsSection() {
    if (widget.pokemon.megaEvolutions.isEmpty) {
      return const SizedBox.shrink();
    }


    return Column(
      children: [
        PokemonMegaEvolutionSection(
          megaEvolutions: widget.pokemon.megaEvolutions,
          backgroundColor: PokemonColors.getTypeColor(widget.pokemon.types.first.name),
          pokemon: widget.pokemon,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

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
            _buildMegaEvolutionsSection(),
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
            Stack(
              alignment: Alignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    _lastRotation = _rotationValue;
                    _autoRotationController.forward(from: 0).then((_) {
                      _lastRotation = _rotationValue;
                    });
                  },
                  onPanStart: (details) {
                    _autoRotationController.stop();
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onPanUpdate: (details) {
                    setState(() {
                      _rotationValue += details.delta.dx * 0.01;
                    });
                  },
                  onPanEnd: (details) {
                    setState(() {
                      _isDragging = false;
                      _lastRotation = _rotationValue;
                    });
                  },
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0008)
                      ..rotateY(_rotationValue),
                    child: Image.network(
                      widget.pokemon.imageUrl!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(
                            Icons.catching_pokemon,
                            size: 100,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
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
          // onPressed: () => context.goToPokemonList(),
          onPressed: () {
            // Primero actualizamos el estado
            setState(() {
              // No es necesario llamar a _toggleFavorite() aquí
              // ya que solo queremos notificar a la pantalla anterior
            });
            // Notificamos a la pantalla anterior que hubo un cambio en favoritos
            Navigator.of(context).pop({'isFavorite': isFavorite});
          },
        ),
        // Botón de Home
        IconButton(
          icon: const Icon(
            Icons.home,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
                  (Route<dynamic> route) => false,
            );
          },
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
              color: isFavorite ? Colors.red : Colors.white,
              size: 28,
            ),
          ),
          onPressed: _toggleFavorite,
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

    // Detectar si es familia de Eevee (incluyendo Eevee y sus evoluciones)
    bool isEeveeFamily = widget.pokemon.evolutions.any((e) => e.id == 133) ||
        widget.pokemon.id == 133;

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
            child: Center(
              child: Text(
                'Evoluciones',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          isEeveeFamily
              ? _buildEeveeEvolutionsFamily()
              : SizedBox(
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

  Widget _buildEeveeEvolutionsFamily() {
    final eevee = widget.pokemon.evolutions.firstWhere(
          (e) => e.id == 133,
      orElse: () => widget.pokemon.evolutions.first,
    );

    final evolutions = widget.pokemon.evolutions
        .where((e) => e.id != 133)
        .toList();

    return Column(
      children: [
        // Eevee en el centro
        SizedBox(
          height: 180,
          child: _buildEvolutionItem(eevee, 0),
        ),
        const SizedBox(height: 16),
        // Flechas indicando múltiples evoluciones
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_downward, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Múltiples evoluciones",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_downward, color: Colors.white),
          ],
        ),
        const SizedBox(height: 16),
        // Grid de evoluciones
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
          ),
          itemCount: evolutions.length,
          itemBuilder: (context, index) {
            return _buildEvolutionItem(evolutions[index], index + 1);
          },
        ),
      ],
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
            children: evolution.types.map((type) {
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

