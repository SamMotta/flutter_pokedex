import 'package:flutter/material.dart';
import 'package:pokedex/models/pokemon_model.dart';
import 'package:pokedex/services/poke_api.dart';
import 'package:pokedex/services/pokemon_type_colors.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PokeAPI pokeApi = PokeAPI();
  List<PokemonModel> pokemons = [];

  String _capitalize(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }

  void loadData() async {
    pokemons = await pokeApi.getPokemons();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Pokédex"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      pokemons = await pokeApi.getPreviousPokemons();
                      setState(() {});
                    },
                    child: const Text(
                      "Anterior",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll<Color>(Colors.deepPurple),
                    ),
                    onPressed: () async {
                      pokemons = await pokeApi.getNextPokemons();
                      setState(() {});
                    },
                    child: const Text(
                      "Próximo",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),

              // Lista de pokemons
              Expanded(
                child: ListView.builder(
                  itemCount: pokemons.length,
                  itemBuilder: (context, index) {
                    var pokemon = pokemons[index];

                    return Card(
                      color: Color(PokemonTypesColors.hexCodes[pokemon.types![0].type!.name]!),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _capitalize(pokemon.name!),
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        for (var type in pokemon.types!)
                                          Container(
                                            decoration: BoxDecoration(
                                              boxShadow: const [
                                                BoxShadow(
                                                  blurRadius: 6,
                                                  color: Colors.black,
                                                  spreadRadius: -1,
                                                ),
                                              ],
                                              borderRadius: BorderRadius.circular(6),
                                              color: Color(
                                                  PokemonTypesColors.hexCodes[type.type!.name]!),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            margin: const EdgeInsets.only(top: 6),
                                            child: Text(
                                              _capitalize(type.type!.name!),
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        "#${pokemon.id}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  FadeInImage.memoryNetwork(
                                    placeholder: kTransparentImage,
                                    image: pokemon.sprites!.other!.officialArtwork!.frontDefault!,
                                    height: 128,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
