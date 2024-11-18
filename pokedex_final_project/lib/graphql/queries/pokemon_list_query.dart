const String queryPokemonList = """
query listPokemons(
 \$types: [String!], 
 \$generations: [Int!],
 \$orderBy: [pokemon_v2_pokemon_order_by!]
  \$searchTerm: String
) {
 pokemon_v2_pokemon(
   limit: 80,
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
           _ilike: \$searchTerm
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
}""";