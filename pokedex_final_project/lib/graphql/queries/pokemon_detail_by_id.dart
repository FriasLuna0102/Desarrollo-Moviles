import 'package:graphql_flutter/graphql_flutter.dart';

import '../../core/models/pokemon.dart';
import '../client.dart';

Future<Pokemon> fetchPokemonDetails(int id) async {
  // Query para obtener un Pokémon específico por ID
  const String queryPokemonById = """
  query getPokemonById(\$id: Int!) {
    pokemon_v2_pokemon(where: {id: {_eq: \$id}}) {
      id
      name
      height
      weight
      pokemon_v2_pokemonsprites {
        sprites
      }
      pokemon_v2_pokemontypes {
        pokemon_v2_type {
          name
        }
      }
      pokemon_v2_pokemonstats {
        base_stat
        pokemon_v2_stat {
          name
        }
      }
      pokemon_v2_pokemonabilities {
        pokemon_v2_ability {
          name
        }
      }
      pokemon_v2_pokemonspecy {
        pokemon_v2_evolutionchain {
          pokemon_v2_pokemonspecies(order_by: {order: asc}) {
            id
            name
            order
          }
        }
      }
      
      pokemon_v2_pokemonmoves(limit: 4) {
      level
      pokemon_v2_move {
        name
        power
        accuracy
        pp
        pokemon_v2_type {
          name
        }
      }
    }
      
    }
  }
""";

  try {

    final client = setupGraphQLClient().value;

    final QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryPokemonById),
        variables: {
          'id': id,
        },
      ),
    );

    if (result.hasException) {
      throw Exception('Error fetching Pokemon: ${result.exception.toString()}');
    }

    final List<dynamic>? pokemonData = result.data?['pokemon_v2_pokemon'];

    if (pokemonData == null || pokemonData.isEmpty) {
      throw Exception('Pokemon not found');
    }

    return Pokemon.fromJson(pokemonData.first);
  } catch (e) {
    print('Error in fetchPokemonDetails: $e');
    rethrow;
  }
}