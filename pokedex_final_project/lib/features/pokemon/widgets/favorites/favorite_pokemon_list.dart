import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../graphql/queries/favorite_pokemon_query.dart';
import '../pokemon_grid_item.dart';

class FavoritePokemonList extends StatefulWidget {
  const FavoritePokemonList({super.key});

  @override
  State<FavoritePokemonList> createState() => _FavoritePokemonListState();
}

class _FavoritePokemonListState extends State<FavoritePokemonList> {
  static const _pageSize = 20;
  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 0);
  List<int> favoriteIds = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteIds = (prefs.getStringList('favorites')?.map(int.parse).toList() ?? [])
        ..sort((a, b) => a.compareTo(b));
    });
    _pagingController.refresh();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      // Calcula el rango de IDs para esta página
      final startIndex = pageKey * _pageSize;
      final endIndex = startIndex + _pageSize;

      // Obtiene los IDs para esta página
      final pageIds = favoriteIds.skip(startIndex).take(_pageSize).toList();

      if (pageIds.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }

      final client = GraphQLProvider.of(context).value;
      final result = await client.query(
        QueryOptions(
          document: gql(queryFavoritePokemon),
          variables: {
            'ids': pageIds,
          },
        ),
      );

      final pokemons = result.data?['pokemon_v2_pokemon'] as List;

      // Ordena los pokémon según el orden en favoriteIds
      pokemons.sort((a, b) {
        final indexA = pageIds.indexOf(a['id']);
        final indexB = pageIds.indexOf(b['id']);
        return indexA.compareTo(indexB);
      });

      final isLastPage = endIndex >= favoriteIds.length;

      if (isLastPage) {
        _pagingController.appendLastPage(pokemons);
      } else {
        _pagingController.appendPage(pokemons, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }


  @override
  Widget build(BuildContext context) {
    return PagedSliverGrid<int, dynamic>(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.85
      ),
      builderDelegate: PagedChildBuilderDelegate(
        itemBuilder: (context, item, index) {

          return PokemonGridItem(pokemon: item);
        },
        firstPageProgressIndicatorBuilder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
        noItemsFoundIndicatorBuilder: (context) => const Center(
          child: Text('No Pokemon Found'),
        ),
      ),
      pagingController: _pagingController,
    );
  }
}
