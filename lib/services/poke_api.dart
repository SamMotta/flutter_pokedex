import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/models/poke_api_model.dart';
import 'package:pokedex/models/pokemon_model.dart';

class PokeAPI {
  final Uri defaultPokeApiUri = Uri.parse("https://pokeapi.co/api/v2/pokemon/");
  PokeAPIModel pokeAPI = PokeAPIModel();

  Future<void> _fetchPokemonAPI({Uri? newUrl}) async {
    // For the first use, it will use defaultPokeApiUri
    Uri fetchUrl = newUrl ?? defaultPokeApiUri;
    var response = await http.get(fetchUrl);
    var json = jsonDecode(response.body);
    pokeAPI = PokeAPIModel.fromJson(json);
  }

  Future<List<PokemonModel>> getNextPokemons() async {
    if (pokeAPI.next == null) return getPokemons();

    var response = await http.get(Uri.parse(pokeAPI.next!));
    var json = jsonDecode(response.body);
    pokeAPI = PokeAPIModel.fromJson(json);

    return await getPokemons(newUrl: Uri.parse(pokeAPI.next!));
  }

  Future<List<PokemonModel>> getPreviousPokemons() async {
    if (pokeAPI.previous == null) return getPokemons();

    var response = await http.get(Uri.parse(pokeAPI.previous!));
    var json = jsonDecode(response.body);
    pokeAPI = PokeAPIModel.fromJson(json);

    return await getPokemons(newUrl: Uri.parse(pokeAPI.previous!));
  }

  Future<List<PokemonModel>> getPokemons({Uri? newUrl}) async {
    await _fetchPokemonAPI(newUrl: newUrl);
    var results = pokeAPI.infoResults;
    var pokemonList = <PokemonModel>[];

    for (var el in results!) {
      Uri pokemonUrl = Uri.parse(el.url!);

      var response = await http.get(pokemonUrl);
      var json = await jsonDecode(response.body);

      PokemonModel model = PokemonModel.fromJson(json);

      pokemonList.add(model);
    }

    return pokemonList;
  }
}
