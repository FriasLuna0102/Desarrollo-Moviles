const String queryPokemonList = """
query listPokemons(
 \$types: [String!], 
 \$generations: [Int!],
 \$orderBy: [pokemon_v2_pokemon_order_by!],
 \$searchName: String,
 \$offset: Int,
 \$limit: Int
) {
  pokemon_v2_pokemon_aggregate {
   aggregate {
     count
   }
 }
 pokemon_v2_pokemon(
   offset: \$offset,
   limit: \$limit,
   order_by: \$orderBy,
   where: {
     _and: [
       {
         pokemon_v2_pokemontypes: {
           pokemon_v2_type: {
             name: {
               _in: \$types
             }
           }
         }
       },
       {
         pokemon_v2_pokemonspecy: {
           generation_id: {
             _in: \$generations
           }
         }
       },
       {
          name: {
            _ilike: \$searchName
          }
       }
     ]
   }
 ) {
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