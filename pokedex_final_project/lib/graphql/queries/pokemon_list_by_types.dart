const String pokemonListByType = """
query orderByTypes(
  \$name: order_by = asc,
  \$offset: Int,
  \$limit: Int,
  \$types: [String!], 
  \$generations: [Int!],
  \$searchName: String
) {
  pokemon_v2_pokemontype(
    order_by: {pokemon_v2_type: {name: \$name}, pokemon_v2_pokemon: {id: asc}},
    offset: \$offset,
    limit: \$limit,
    where: {
      _and: [
        {
          pokemon_v2_type: {
            name: {
              _in: \$types
            }
          }
        },
        {
          pokemon_v2_pokemon: {
            pokemon_v2_pokemonspecy: {
              generation_id: {
                _in: \$generations
              }
            },
            name: {
              _ilike: \$searchName
            }
          }
        }
      ]
    }
  ) {
    pokemon_v2_pokemon {
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
}
""";