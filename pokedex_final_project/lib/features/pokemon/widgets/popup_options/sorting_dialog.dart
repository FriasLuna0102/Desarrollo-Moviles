import 'package:flutter/material.dart';
import 'package:pokedex_final_project/features/pokemon/widgets/popup_options/sorting_section.dart';

class SortingDialog extends StatefulWidget {
  final SortOption currentSort;
  final Function(SortOption) onSortChanged;

  const SortingDialog({
    super.key,
    required this.currentSort,
    required this.onSortChanged
  });

  @override
  State<SortingDialog> createState() => _SortingDialogState();
}

class _SortingDialogState extends State<SortingDialog> {
  late SortOption selectedSort;

  @override
  void initState() {
    super.initState();
    selectedSort = widget.currentSort;
  }

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
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.red.shade200,
                        width: 1,
                      ),
                    ),
                  ),
                  child: const Text(
                    'Sort Pokémon',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                SortingSection(
                  selectedOption: selectedSort,
                  onSortChange: (newSort) {
                    setState(() {
                      selectedSort = newSort;
                      widget.onSortChanged(newSort);
                    });
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
