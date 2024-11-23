const String searchPokemonByNumberQuery = """
query searchPokemonByNumber(\$number: Int) {
  pokemon_v2_pokemon(where: {id: {_eq: \$number}}) {
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
    pokemon_v2_pokemonspecy {
      generation_id
    }
  }
}""";