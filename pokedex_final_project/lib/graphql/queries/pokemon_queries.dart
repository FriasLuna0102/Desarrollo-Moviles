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
          pokemonV2TypeefficaciesByTargetTypeId(
            limit: 4,
            where: {damage_factor: {_gt: 100}},
            order_by: {damage_factor: desc}
          ) {
            damage_factor
            pokemon_v2_type {
              name
            }
          }
          pokemon_v2_typeefficacies(
            limit: 4,
            where: {damage_factor: {_gt: 100}},
            order_by: {damage_factor: desc}
          ) {
            damage_factor
            pokemonV2TypeByTargetTypeId {
              name
            }
          }
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
            pokemon_v2_pokemons {
              id
              name
              pokemon_v2_pokemontypes {
                pokemon_v2_type {
                  name
                }
              }
              pokemon_v2_pokemonforms {
                  id
                  form_name
                  name
              }
            }
          }
        }
        pokemon_v2_pokemonspeciesnames(where: {language_id: {_eq: 9}}) {
          genus
        }
      }
      pokemon_v2_pokemonmoves(
        where: {
          move_learn_method_id: {_eq: 1},
          level: {_gt: 0}
        },
        order_by: {level: asc},
        limit: 100
      ) {
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