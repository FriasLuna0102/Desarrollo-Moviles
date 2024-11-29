import 'package:flutter/material.dart';

enum SortField { id, name, type, ability, bst }

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
    SortOption(
      field: SortField.type,
      order: SortOrder.asc,
      label: 'Type (A-Z)',
    ),
    SortOption(
      field: SortField.type,
      order: SortOrder.desc,
      label: 'Type (Z-A)',
    ),
    SortOption(
      field: SortField.ability,
      order: SortOrder.asc,
      label: 'Ability (A-Z)',
    ),
    SortOption(
      field: SortField.ability,
      order: SortOrder.desc,
      label: 'Ability (Z-A)',
    ),
    SortOption(
      field: SortField.bst,
      order: SortOrder.desc,
      label: 'Power (Highest)',
    ),
    SortOption(
      field: SortField.bst,
      order: SortOrder.asc,
      label: 'Power (Lowest)',
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
