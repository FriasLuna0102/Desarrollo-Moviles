import 'package:flutter/material.dart';
import 'package:pokedex_final_project/features/pokemon/widgets/popup_options/sorting_section.dart';

import '../pokemon/widgets/list_pokemon.dart';
import '../pokemon/widgets/popup_options/action_button_expandable.dart';
import '../pokemon/widgets/popup_options/expandable_fab.dart';
import '../pokemon/widgets/popup_options/popup_options_for_list.dart';
import '../pokemon/widgets/popup_options/sorting_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';

  Map<String, Set<String>> activeFilters = {
    'generations': {},
    'types': {},
  };

  SortOption currentSort = const SortOption(
    field: SortField.id,
    order: SortOrder.asc,
    label: 'Lowest Number (First)',
  );

  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text("Pokedex",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 27
              ),
            ),
            backgroundColor: Colors.red,
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: false,
            bottom: AppBar(
              backgroundColor: Colors.red,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white
                  ),
                  child: TextField(
                    onChanged: _onSearchChanged,
                    decoration: const InputDecoration(
                        hintText: "Search",
                        hintStyle: TextStyle(color: Colors.grey),
                        suffixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10)
                    ),
                  ),
                ),
              ),
            ),
          ),
          ListPokemon(
            activeFilters: activeFilters,
            currentSort: currentSort,
            searchQuery: _searchQuery,
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(
          distance: 60,
          children: [
            ActionButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return SortingDialog(
                      currentSort: currentSort,
                      onSortChanged: (sort) {
                        setState(() {
                          currentSort = sort;
                        });
                      },
                    );
                  },
                )
              },
              icon: const Icon(Icons.sort),
            ),
            ActionButton(
              onPressed: () => {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PopupOptionsForList(
                      currentFilters: activeFilters,
                      onFiltersChanged: (filters) {
                        setState(() {
                          activeFilters = filters;
                        });
                      },
                    );
                  },
                )
              },
              icon: const Icon(Icons.filter_list),
            ),
          ]
      ),
    );
  }
}