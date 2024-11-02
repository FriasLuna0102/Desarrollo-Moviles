import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pokedex_final_project/features/screens/pokemon_detail.dart';
import '../../../graphql/queries/pokemon_queries.dart';
import '../../../core/models/pokemon.dart';

class PokemonList extends StatelessWidget {
  const PokemonList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pokémon List"),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(queryPokemon),
        ),
        builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
          if (result.hasException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${result.exception.toString()}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            );
          }

          if (result.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando Pokémon...'),
                ],
              ),
            );
          }

          final List pokemonsJson = result.data!['pokemon_v2_pokemon'];
          final List<Pokemon> pokemons = pokemonsJson
              .map((json) => Pokemon.fromJson(json))
              .toList();

          return RefreshIndicator(
            onRefresh: () {
              refetch?.call();
              return Future.value();
            },

            child: ListView.builder(
              itemCount: pokemons.length,
              itemBuilder: (context, index) {
                final pokemon = pokemons[index];

                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetailScreen(pokemon: pokemon),
                          ),
                        );
                      },
                      title: Text(
                        pokemon.name.toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'ID: ${pokemon.id}',
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      leading: pokemon.imageUrl != null
                          ? Hero(
                        tag: 'pokemon-${pokemon.id}',
                        child: Image.network(
                          pokemon.imageUrl!,
                          width: 56,
                          height: 56,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.image_not_supported);
                          },
                        ),
                      )
                          : const Icon(Icons.image_not_supported),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                      ),
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              },
            ),
          );

        },
      ),
    );
  }
}