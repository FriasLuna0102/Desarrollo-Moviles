const String queryPokemonList = """
query listPokemons {
  pokemon_v2_pokemon(limit: 80) {
    id
    name
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        name
      }
    }
    pokemon_v2_pokemonsprites {
      sprites(path: "other.official-artwork.front_default")
    }
  }
}""";