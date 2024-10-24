const String queryPokemon = """
  query {
    pokemon_v2_pokemon(limit: 5) {
      id
      name
      height
      weight
    }
  }
""";