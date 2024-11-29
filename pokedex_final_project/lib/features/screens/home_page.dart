import 'package:flutter/material.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:string_validator/string_validator.dart';
import '../pokemon/widgets/favorites/favorite_pokemon_list.dart';
import '../pokemon/widgets/list_pokemon.dart';
import '../pokemon/widgets/popup_options/action_button_expandable.dart';
import '../pokemon/widgets/popup_options/expandable_fab.dart';
import '../pokemon/widgets/popup_options/popup_options_for_list.dart';
import '../pokemon/widgets/popup_options/sorting_dialog.dart';
import '../pokemon/widgets/popup_options/sorting_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchName = '';
  int _searchNumber = 0;
  bool _updateFilter = false;
  bool _showFavorites = false;

  Map<String, Set<String>> activeFilters = {
    'generations': {},
    'types': {},
  };

  SortOption currentSort = const SortOption(
    field: SortField.id,
    order: SortOrder.asc,
    label: 'Lowest Number (First)',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text(
              "Pokedex",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 27),
            ),
            backgroundColor: Colors.red,
            floating: true,
            pinned: true,
            snap: true,
            centerTitle: false,
            bottom: AppBar(
              backgroundColor: Colors.red,
              title: Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        value = value.trim();
                        if (isNumeric(value)) {
                          _searchNumber = int.parse(value);
                          _searchName = '';
                        } else {
                          _searchName = value;
                          _searchNumber = 0;
                        }
                      });
                    },
                  ),
                ),
              ),
            ),
          ),
          SliverAnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _showFavorites
                ? FavoritePokemonList(key: const ValueKey('favorites'))
                : ListPokemon(
                    key: const ValueKey('all'),
                    activeFilters: activeFilters,
                    currentSort: currentSort,
                    searchName: _searchName,
                    searchNumber: _searchNumber,
                    updateFilter: _updateFilter,
                  ),
          ),
        ],
      ),
      floatingActionButton: ExpandableFab(distance: 60, children: [
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
                      _updateFilter = true;
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
                      _updateFilter = true;
                    });
                  },
                );
              },
            )
          },
          icon: const Icon(Icons.filter_list),
        ),
        ActionButton(
          onPressed: () => {
            setState(() {
              _showFavorites = !_showFavorites;
            })
          },
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              _showFavorites ? Icons.favorite : Icons.favorite_border,
              key: ValueKey(_showFavorites),
              color: _showFavorites ? Colors.red : null,
            ),
          ),
        ),
      ]),
    );
  }
}
