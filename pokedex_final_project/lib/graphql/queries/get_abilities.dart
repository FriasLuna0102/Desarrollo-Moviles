const String getAbilities = """
query getAbilities(\$searchText: String) {
  pokemon_v2_ability(
    where: {name: {_ilike: \$searchText}}
    order_by: {name: asc}
  ) {
    name
    id
  }
}
""";