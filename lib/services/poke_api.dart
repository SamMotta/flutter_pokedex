import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:pokedex/models/poke_api_response_model.dart';
import 'package:pokedex/models/pokemon_model.dart';

class PokeAPI {
  final Uri defaultPokeApiUri = Uri.parse("https://pokeapi.co/api/v2/pokemon/");
  PokeResponseModel pokeResponseModel = PokeResponseModel();

  Future<void> _fetchPokemonAPI({Uri? newUrl}) async {
    // For the first use, it will use defaultPokeApiUri
    Uri fetchUrl = newUrl ?? defaultPokeApiUri;
    var response = await http.get(fetchUrl);
    var json = jsonDecode(response.body);

    var results = _parsePokeResponseResults(json);

    pokeResponseModel.count = json["count"];
    pokeResponseModel.next = json["next"];
    pokeResponseModel.previous = json["previous"];
    pokeResponseModel.results = results;
  }

  Future<List<PokemonModel>> getNextPokemons() async {
    if (pokeResponseModel.next == null) return getPokemons();

    var response = await http.get(Uri.parse(pokeResponseModel.next!));
    var json = jsonDecode(response.body);

    var results = _parsePokeResponseResults(json);

    pokeResponseModel.count = json["count"];
    pokeResponseModel.next = json["next"];
    pokeResponseModel.previous = json["previous"];
    pokeResponseModel.results = results;
    return await getPokemons(newUrl: Uri.parse(pokeResponseModel.next!));
  }

  Future<List<PokemonModel>> getPreviousPokemons() async {
    if (pokeResponseModel.previous == null) return getPokemons();

    var response = await http.get(Uri.parse(pokeResponseModel.previous!));
    var json = jsonDecode(response.body);

    var results = _parsePokeResponseResults(json);

    pokeResponseModel.count = json["count"];
    pokeResponseModel.next = json["next"];
    pokeResponseModel.previous = json["previous"];
    pokeResponseModel.results = results;
    return await getPokemons(newUrl: Uri.parse(pokeResponseModel.previous!));
  }

  Future<List<PokemonModel>> getPokemons({Uri? newUrl}) async {
    await _fetchPokemonAPI(newUrl: newUrl);
    var results = pokeResponseModel.results;
    var pokemonList = <PokemonModel>[];

    for (var el in results) {
      Uri pokemonUrl = Uri.parse(el['url']!);

      var response = await http.get(pokemonUrl);
      var json = await jsonDecode(response.body);

      PokemonModel model = PokemonModel(
        json['id'],
        json['name'],
        _parsePokemonTypes(json),
        json['sprites']['other']['official-artwork']['front_default'],
      );

      pokemonList.add(model);
    }

    return pokemonList;
  }

  List<Map<String, String>> _parsePokeResponseResults(dynamic json) {
    return (json["results"] as List)
        .map<Map<String, String>>((e) => {"name": e["name"], "url": e["url"]})
        .toList();
  }

  List<Map<String, Object>> _parsePokemonTypes(dynamic json) {
    var types = (json['types'] as List)
        .map((e) => {
              "slot": e["slot"].toString(),
              "type": {
                "name": e['type']['name'],
                "url": e['type']['url'],
              }
            })
        .toList();

    return types;
  }
}
