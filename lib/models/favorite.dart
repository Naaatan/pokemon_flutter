import 'package:flutter/cupertino.dart';
import 'package:pokemon_flutter/db/favorites.dart';

class Favorite {
  final int pokeId;

  Favorite({
    required this.pokeId,
  });

  Map<String, dynamic> toMap() {
    return {'id': pokeId};
  }
}

class FavoriteNotifier extends ChangeNotifier {
  final List<Favorite> _favs = [];

  List<Favorite> get favs => _favs;

  FavoriteNotifier() {
    syncDb();
  }

  void syncDb() async {
    var val = await FavoritesDb.read();
    _favs
      ..clear()
      ..addAll(val);
    notifyListeners();
  }

  void add(Favorite fav) async {
    await FavoritesDb.create(fav);
    syncDb();
  }

  void delete(int id) async {
    await FavoritesDb.delete(id);
    syncDb();
  }

  void toggle(Favorite fav) {
    if (isExist(fav.pokeId)) {
      delete(fav.pokeId);
    } else {
      add(fav);
    }
  }

  bool isExist(int id) {
    if (_favs.indexWhere((fav) => fav.pokeId == id) < 0) {
      return false;
    } else {
      return true;
    }
  }
}
