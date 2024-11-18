import 'package:flutter/material.dart';

enum SortField { id, name }
enum SortOrder { asc, desc }

class SortOption {
  final SortField field;
  final SortOrder order;
  final String label;

  const SortOption({
    required this.field,
    required this.order,
    required this.label,
  });
}

class SortingSection extends StatelessWidget {
  final SortOption selectedOption;
  final Function(SortOption) onSortChange;

  static const List<SortOption> options = [
    SortOption(
      field: SortField.id,
      order: SortOrder.asc,
      label: 'Lowest Number (First)',
    ),
    SortOption(
      field: SortField.id,
      order: SortOrder.desc,
      label: 'Highest Number (First)',
    ),
    SortOption(
      field: SortField.name,
      order: SortOrder.asc,
      label: 'Name (A-Z)',
    ),
    SortOption(
      field: SortField.name,
      order: SortOrder.desc,
      label: 'Name (Z-A)',
    ),
  ];

  const SortingSection({
    super.key,
    required this.selectedOption,
    required this.onSortChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...options.map((option) => RadioListTile<SortOption>(
          title: Text(option.label),
          value: option,
          groupValue: selectedOption,
          onChanged: (value) => onSortChange(value!),
        )),
      ],
    );
  }
}
