import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/client.dart';
import 'screens/pokemon_list.dart';

void main() {
  final ValueNotifier<GraphQLClient> client = setupGraphQLClient();
  runApp(MyApp(client: client));
}

class MyApp extends StatelessWidget {
  final ValueNotifier<GraphQLClient> client;

  const MyApp({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        title: 'PokeAPI GraphQL',
        home: PokemonList(),
      ),
    );
  }
}
