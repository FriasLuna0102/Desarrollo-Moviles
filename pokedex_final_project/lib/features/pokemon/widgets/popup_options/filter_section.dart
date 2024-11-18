import 'package:flutter/material.dart';

class FilterSection extends StatefulWidget {
  final String title;
  final List<String> options;
  final Map<String, Set<String>> initialSelected;
  final Function(Set<String>) onFilterChange;

  const FilterSection({
    super.key,
    required this.title,
    required this.options,
    required this.initialSelected,
    required this.onFilterChange,
  });

  @override
  State<FilterSection> createState() => _FilterSectionState();
}

class _FilterSectionState extends State<FilterSection> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () {
            setState(() {
              isExpanded = !isExpanded;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 6.0),
            child: Row(
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 200),
                  turns: isExpanded ? 0.5 : 0,
                  child: const Icon(Icons.arrow_drop_down_sharp),
                ),
              ],
            ),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: ClipRect(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: isExpanded ? null : 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: widget.options.map( (option) {
                    final isSelected = widget.initialSelected[widget.title.toLowerCase()]?.contains(option) ?? false;                    return FilterChip(
                      label: Text(
                        option,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                        ),
                      ),
                      selected: isSelected,
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        setState(() {
                          if (selected) {
                            widget.initialSelected[widget.title.toLowerCase()]
                                ?.add(option);
                          } else {
                            widget.initialSelected[widget.title.toLowerCase()]
                                ?.remove(option);
                          }
                          widget.onFilterChange(widget.initialSelected[widget.title.toLowerCase()]!);
                        });
                      },
                      selectedColor: Colors.blue,
                      backgroundColor: Colors.grey,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
