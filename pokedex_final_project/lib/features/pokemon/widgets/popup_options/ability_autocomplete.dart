import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../graphql/queries/get_abilities.dart';

class AbilityAutocomplete extends StatefulWidget {
  final Function(String) onAbilitySelected;
  final ValueNotifier<String> selectedAbility;

  const AbilityAutocomplete({
    super.key,
    required this.onAbilitySelected,
    required this.selectedAbility,
  });

  @override
  State<AbilityAutocomplete> createState() => _AbilityAutocompleteState();
}

class _AbilityAutocompleteState extends State<AbilityAutocomplete> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(getAbilities),
        variables: {
          'searchText': '%${searchText.toLowerCase()}%',
        },
      ),
      builder: (QueryResult result, {fetchMore, refetch}) {
        if (result.hasException) {
          return Text('Error: ${result.exception.toString()}');
        }

        final List<String> abilities = result.data?['pokemon_v2_ability']
            ?.map<String>((ability) => ability['name'] as String)
            .toList() ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                setState(() {
                  searchText = textEditingValue.text;
                });
                return abilities.where((ability) {
                  return ability.toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String ability) {
                widget.selectedAbility.value = ability;
                widget.onAbilitySelected(ability);
              },
              fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    labelText: 'Search by ability',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    suffixIcon: result.isLoading
                        ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2)
                    )
                        : const Icon(Icons.search),
                  ),
                );
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    child: Container(
                      width: 300,
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (context, index) {
                          final ability = options.elementAt(index);
                          return ListTile(
                            title: Text(ability),
                            onTap: () => onSelected(ability),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: widget.selectedAbility,
              builder: (context, ability, _) {
                return ability.isNotEmpty
                    ? Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Selected Ability: $ability',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                )
                    : SizedBox();
              },
            ),
          ],
        );
      },
    );
  }
}