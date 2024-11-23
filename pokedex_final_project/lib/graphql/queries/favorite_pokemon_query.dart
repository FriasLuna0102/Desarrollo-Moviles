const String queryFavoritePokemon = """
query getFavorites(\$ids: [Int!]!) {
  pokemon_v2_pokemon(where: {id: {_in: \$ids}}, order_by: {id: asc}) {
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
}
""";