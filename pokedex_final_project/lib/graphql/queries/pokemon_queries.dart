const String queryPokemon = """
  query {
  pokemon_v2_pokemon(limit: 10) {
    id
    name
    height
    weight
    pokemon_v2_pokemonsprites {
      sprites
    }
    pokemon_v2_pokemontypes {
      pokemon_v2_type {
        name
      }
    }
    pokemon_v2_pokemonstats {
      base_stat
      pokemon_v2_stat {
        name
      }
    }
    pokemon_v2_pokemonabilities {
      pokemon_v2_ability {
        name
      }
    }
    pokemon_v2_pokemonspecy {
      pokemon_v2_evolutionchain {
        pokemon_v2_pokemonspecies(order_by: {order: asc}) {
          id
          name
          order
        }
      }
    }
    
    pokemon_v2_pokemonmoves(limit: 4) {
      level
      pokemon_v2_move {
        name
        power
        accuracy
        pp
        pokemon_v2_type {
          name
        }
      }
    }
  }
  }
""";