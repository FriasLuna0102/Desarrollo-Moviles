import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../graphql/queries/pokemon_queries.dart';
import 'pokemon_detail.dart';

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
        builder: (QueryResult result, { VoidCallback? refetch, FetchMore? fetchMore }) {
          if (result.hasException) {
            return Text(result.exception.toString());
          }

          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final List pokemons = result.data!['pokemon_v2_pokemon'];

          return ListView.builder(
            itemCount: pokemons.length,
            itemBuilder: (context, index) {
              final pokemon = pokemons[index];
              return Column(
                children: [
                  ListTile(
                    title: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PokemonDetail(pokemon: pokemon),
                          ),
                        );
                      },
                      child: Text(pokemon['name'], ),
                    ),
                    subtitle: Text('ID: ${pokemon['id']}'),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(pokemon['id'].toString().substring(0, 1)),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 16,
                    endIndent: 16,
                  ), // Divider para marcar el final de cada elemento
                ],
              );
            },
          );

        },
      ),
    );
  }
}