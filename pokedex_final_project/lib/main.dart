import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'graphql/client.dart';
import 'features/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: setupGraphQLClient(),

      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Pokedex Flutter",
        theme: ThemeData(
            primarySwatch: Colors.red
        ),

        home: const HomePage(),
      ),
    );
  }
}
