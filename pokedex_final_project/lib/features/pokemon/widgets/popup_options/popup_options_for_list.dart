import 'package:flutter/material.dart';

import 'filter_section.dart';

class PopupOptionsForList extends StatefulWidget {
  final Map<String, Set<String>> currentFilters;
  final Function(Map<String, Set<String>>) onFiltersChanged;

  const PopupOptionsForList({super.key, required this.onFiltersChanged, required this.currentFilters});

  @override
  State<PopupOptionsForList> createState() => _PopupOptionsForListState();
}

class _PopupOptionsForListState extends State<PopupOptionsForList> {

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 12,
      backgroundColor: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red.shade700,
                width: 2
          ),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2)
            )
          ]
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(1.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FilterSection(
                  title: "Generations",
                  options: [
                    "Generation I",    // 1996 (Red, Blue, Yellow)
                    "Generation II",   // 1999 (Gold, Silver, Crystal)
                    "Generation III",  // 2002 (Ruby, Sapphire, Emerald)
                    "Generation IV",   // 2006 (Diamond, Pearl, Platinum)
                    "Generation V",    // 2010 (Black, White, Black 2, White 2)
                    "Generation VI",   // 2013 (X, Y, Omega Ruby, Alpha Sapphire)
                    "Generation VII",  // 2016 (Sun, Moon, Ultra Sun, Ultra Moon)
                    "Generation VIII", // 2019 (Sword, Shield, Brilliant Diamond, Shining Pearl)
                    "Generation IX",   // 2022 (Scarlet, Violet)
                  ],
                  initialSelected: widget.currentFilters,
                  onFilterChange: (filters) {
                    widget.currentFilters['generations'] = filters;
                    widget.onFiltersChanged(widget.currentFilters);
                  },
                ),
                FilterSection(
                  title: "Types",
                  options: [
                    "Normal",
                    "Fire",
                    "Water",
                    "Electric",
                    "Grass",
                    "Ice",
                    "Fighting",
                    "Poison",
                    "Ground",
                    "Flying",
                    "Psychic",
                    "Bug",
                    "Rock",
                    "Ghost",
                    "Dragon",
                    "Dark",
                    "Steel",
                    "Fairy"
                  ],
                  initialSelected: widget.currentFilters,
                  onFilterChange: (filters) {
                    setState(() {
                      widget.currentFilters['types'] = filters;
                      widget.onFiltersChanged(widget.currentFilters);
                    });
                  },
                ),
                // FilterSection(
                //   title: "Abilities",
                //   options: [
                //     "Overgrow",
                //     "Chlorophyll",
                //     "Blaze",
                //     "Solar Power",
                //     "Torrent",
                //     "Rain Dish",
                //     "Shield Dust",
                //     "Run Away",
                //     "Keen Eye",
                //     "Intimidate",
                //     "Static",
                //     "Lightning Rod",
                //   ],
                //   onFilterChange: (filters) {
                //     selectedFilters['types'] = filters;
                //     widget.onFiltersChanged(selectedFilters);
                //   },
                // )
              ],
            ),
          ),
        ),
      ),

    );

  }
}
