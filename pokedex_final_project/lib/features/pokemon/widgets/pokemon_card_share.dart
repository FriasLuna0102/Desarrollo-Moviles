import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../../../core/models/pokemon.dart';
import '../../../core/models/pokemon_tcg_models.dart';
import '../../../core/services/pokemon_tcg_service.dart';
import '../../../core/theme/pokemon_colors.dart';
import 'custom_pokemon_card.dart';

class PokemonCardShareScreen extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonCardShareScreen({Key? key, required this.pokemon}) : super(key: key);

  @override
  State<PokemonCardShareScreen> createState() => _PokemonCardShareScreenState();
}

class _PokemonCardShareScreenState extends State<PokemonCardShareScreen> with SingleTickerProviderStateMixin {
  List<PokemonCard> cards = [];
  bool isLoading = true;
  bool showCustomCard = false;
  late TabController _tabController;
  final GlobalKey customCardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCards();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCards() async {
    try {
      final loadedCards = await PokemonTCGService.searchCardsByPokemonName(
        widget.pokemon.name,
      );
      setState(() {
        cards = loadedCards;
        isLoading = false;
        // Si no hay cartas, automáticamente mostrar la tarjeta personalizada
        if (cards.isEmpty) {
          _tabController.animateTo(1);
        }
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        _tabController.animateTo(1);
      });
    }
  }

  Future<void> _shareCard(PokemonCard card) async {
    try {
      final response = await http.get(Uri.parse(card.imageUrl));
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final path = '${temp.path}/pokemon_card.png';
      File(path).writeAsBytesSync(bytes);

      await Share.shareXFiles(
        [XFile(path)],
        text: '¡Mira esta carta de ${card.name}!',
      );
    } catch (e) {
      print('Error sharing card: $e');
    }
  }

  Future<void> _shareCustomCard() async {
    try {
      RenderRepaintBoundary boundary = customCardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();
        final temp = await getTemporaryDirectory();
        final file = await File('${temp.path}/pokemon_card.png').create();
        await file.writeAsBytes(pngBytes);

        await Share.shareXFiles(
          [XFile(file.path)],
          text: '¡Mira este Pokémon! ${widget.pokemon.name.toUpperCase()}',
        );
      }
    } catch (e) {
      print('Error al capturar la imagen: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Drag Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Title and Tabs
              TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Cartas TCG'),
                  Tab(text: 'Carta Personalizada'),
                ],
                labelColor: Colors.black,
                indicatorColor: PokemonColors.getTypeColor(widget.pokemon.types.first.name),
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // TCG Cards Tab
                    _buildTCGCardsView(scrollController),

                    // Custom Card Tab
                    _buildCustomCardView(scrollController),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTCGCardsView(ScrollController scrollController) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (cards.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No se encontraron cartas TCG'),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => _tabController.animateTo(1),
              child: const Text('Ver carta personalizada'),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      controller: scrollController,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return GestureDetector(
          onTap: () => _shareCard(card),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Image.network(
                      card.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.share, size: 20),
                      SizedBox(width: 4),
                      Text('Compartir'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCustomCardView(ScrollController scrollController) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomPokemonCard(
              cardKey: customCardKey,  // Pasamos la key
              pokemon: widget.pokemon,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _shareCustomCard,
            icon: const Icon(Icons.share),
            label: const Text('Compartir carta personalizada'),
            style: ElevatedButton.styleFrom(
              backgroundColor: PokemonColors.getTypeColor(widget.pokemon.types.first.name),
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}