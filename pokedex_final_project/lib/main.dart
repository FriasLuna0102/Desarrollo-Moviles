import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'graphql/client.dart';
import 'features/screens/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.pokedex.audio',
    androidNotificationChannelName: 'Pokemon Cries',
    androidNotificationOngoing: true,
  );

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