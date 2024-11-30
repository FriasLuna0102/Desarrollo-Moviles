import 'package:flutter/material.dart';

import '../../screens/home_page.dart';

class NavigationUtils {
  static void navigateToFilteredList({
    required BuildContext context,
    String? type,
    String? ability,
  }) {
    assert(!(type != null && ability != null), 'Cannot filter by both type and ability');

    final Map<String, Set<String>> activeFilters = {
      'generations': {},
      'types': type != null ? {type} : {},
      'abilities': ability != null ? {ability} : {},
    };

    // Navegar a HomePage con los filtros aplicados
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => HomePage(
          initialFilters: activeFilters,
          showFilteredResults: true,
        ),
      ),
          (route) => false, // Elimina todas las rutas anteriores del stack
    );
  }
}