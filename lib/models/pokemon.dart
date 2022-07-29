import 'package:flutter/cupertino.dart';
import 'package:pokemon_flutter/api/pokapi.dart';

class PokemonsNotifier extends ChangeNotifier {
  final Map<int, Pokemon?> _pokeMap = {};

  Map<int, Pokemon?> get pokes => _pokeMap;

  void addPoke(Pokemon poke) {
    _pokeMap[poke.id] = poke;
    notifyListeners();
  }

  void fetchPoke(int id) async {
    _pokeMap[id] = null;
    addPoke(await fetchPokemon(id));
  }

  Pokemon? byId(int id) {
    if (!_pokeMap.containsKey(id)) {
      fetchPoke(id);
    }
    return _pokeMap[id];
  }
}

class Pokemon {
  final int id;
  final String name;
  final List<String> types;
  final String imageUrl;
  final int hp;
  final int attack;
  final int defense;
  final int speed;
  final int spAttack;
  final int spDefense;
  final String description;
  final double height;
  final double weight;
  final String species;

  Pokemon({
    required this.id,
    required this.name,
    required this.types,
    required this.imageUrl,
    required this.hp,
    required this.attack,
    required this.defense,
    required this.speed,
    required this.spAttack,
    required this.spDefense,
    required this.description,
    required this.height,
    required this.weight,
    required this.species,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json, Map<String, dynamic> secJson) {
    // inner function
    List<String> typesToList(dynamic types) {
      List<String> ret = [];
      for (int i = 0; i < types.length; i++) {
        ret.add(types[i]['type']['name']);
      }
      return ret;
    }

    // 日本語名前取得
    List names = secJson['names'];
    int? nameIndex;
    for (int i = 0; i < names.length; i++) {
      var language = secJson['names'][i]['language']['name'];
      if (language == 'ja') {
        nameIndex = i;
      }
    }

    // 日本語フレーバーテキストインデックス取得
    List flavorTexts = secJson['flavor_text_entries'];
    int? flavorIndex;
    for (int i = 0; i < flavorTexts.length; i++) {
      var language = secJson['flavor_text_entries'][i]['language']['name'];
      if (language == 'ja') {
        flavorIndex = i;
      }
    }

    // 分類
    List species = secJson['genera'];
    int? specIndex;
    for (int i = 0; i < species.length; i++) {
      var language = secJson['genera'][i]['language']['name'];
      if (language == 'ja') {
        specIndex = i;
      }
    }

    return Pokemon(
      id: json['id'],
      name: secJson['names'][nameIndex]['name'],
      types: typesToList(json['types']),
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      hp: json['stats'][0]['base_stat'],
      attack: json['stats'][1]['base_stat'],
      defense: json['stats'][2]['base_stat'],
      spAttack: json['stats'][3]['base_stat'],
      spDefense: json['stats'][4]['base_stat'],
      speed: json['stats'][5]['base_stat'],
      description: secJson['flavor_text_entries'][flavorIndex]['flavor_text'],
      height: json['height'] / 10,
      weight: json['weight'] / 10,
      species: secJson['genera'][specIndex]['genus'],
    );
  }
}
