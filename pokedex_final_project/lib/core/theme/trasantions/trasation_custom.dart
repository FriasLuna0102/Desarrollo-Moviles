import 'package:flutter/material.dart';
import 'package:pokedex_final_project/features/screens/home_page.dart';

import '../../../features/screens/pokemon_detail.dart';
import '../../models/pokemon.dart';

class PageTransitions {
  // Transición con fade y slide
  static PageRouteBuilder<T> fadeAndSlide<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
    Offset startOffset = const Offset(0.0, 0.25),
  }) {
    return PageRouteBuilder<T>(
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: startOffset,
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

}

extension NavigationExtensions on BuildContext {
  void goToPokemonDetail(Pokemon pokemon) {
    Navigator.push(
      this,
      PageTransitions.fadeAndSlide(
        page: PokemonDetailScreen(pokemon: pokemon),
      ),
    );
  }

  void goToPokemonList() {
    Navigator.pushReplacement(
      this,
      PageTransitions.fadeAndSlide(
        page: const HomePage(),
      ),
    );
  }
}