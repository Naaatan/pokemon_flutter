import 'package:flutter/material.dart';
import 'package:pokemon_flutter/poke_grid_item.dart';
import 'package:pokemon_flutter/poke_list_item.dart';
import 'package:provider/provider.dart';

import 'const/pokeapi.dart';
import 'models/favorite.dart';
import 'models/pokemon.dart';

class PokeList extends StatefulWidget {
  const PokeList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PokeListState();
}

class _PokeListState extends State<PokeList> {
  static const int pageSize = 30;
  static const double _scrollThreshold = 0.7;
  int _currentPage = 1;
  bool isFavoriteMode = false;
  bool isGridMode = false;

  int itemCount(int page, int favsCount) {
    int ret = pageSize * page;
    if (isFavoriteMode && ret > favsCount) {
      ret = favsCount;
    }
    if (ret > pokeMaxId) {
      ret = pokeMaxId;
    }
    return ret;
  }

  int itemId(int index, List<Favorite> favs) {
    int ret = index + 1;
    if (isFavoriteMode) {
      ret = favs[index].pokeId;
    }
    return ret;
  }

  bool isLastPage(int page, int favsCount) {
    if (isFavoriteMode) {
      if (_currentPage * pageSize < favsCount) {
        return false;
      }
      return true;
    } else {
      if (_currentPage * pageSize < pokeMaxId) {
        return false;
      }
      return true;
    }
  }

  void changeFavMode(bool currentMode) {
    setState(() => isFavoriteMode = !currentMode);
  }

  void changeGridMode(bool currentMode) {
    setState(() => isGridMode = !currentMode);
  }

  Widget loadScroll({required Widget child, required void Function() onLoad}) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        final scrollPosition = scrollInfo.metrics.pixels / scrollInfo.metrics.maxScrollExtent;
        if (scrollPosition > _scrollThreshold) {
          // 閾値以上スクロールされたら関数実行
          onLoad();
        }
        return false;
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) => Column(
        children: [
          TopHeadMenu(
            isFavoriteMode: isFavoriteMode,
            changeFavMode: changeFavMode,
            isGridMode: isGridMode,
            changeGridMode: changeGridMode,
          ),
          Expanded(
            child: Consumer<PokemonsNotifier>(
              builder: (context, pokes, child) {
                if (itemCount(_currentPage, favs.favs.length) < 1) {
                  return const Text("no data");
                } else {
                  if (isGridMode) {
                    return loadScroll(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: itemCount(_currentPage, favs.favs.length) + 1,
                        itemBuilder: (context, index) {
                          if (index == itemCount(_currentPage, favs.favs.length)) {
                            return Padding(
                              padding: const EdgeInsets.all(16),
                              child: OutlinedButton(
                                child: const Text('more'),
                                style: OutlinedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                onPressed: isLastPage(_currentPage, favs.favs.length)
                                    ? null
                                    : () => {
                                          setState(() => _currentPage++),
                                        },
                              ),
                            );
                          } else {
                            return PokeGridItem(poke: pokes.byId(itemId(index, favs.favs)));
                          }
                        },
                      ),
                      onLoad: () {
                        if (!isLastPage(_currentPage, favs.favs.length)) {
                          setState(() => _currentPage++);
                        }
                      },
                    );
                  } else {
                    return loadScroll(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
                        itemCount: itemCount(_currentPage, favs.favs.length) + 1,
                        itemBuilder: (context, index) {
                          if (index == itemCount(_currentPage, favs.favs.length)) {
                            return OutlinedButton(
                              onPressed: isLastPage(_currentPage, favs.favs.length)
                                  ? null
                                  : () => {
                                        setState(() => _currentPage++),
                                      },
                              child: const Text('more'),
                            );
                          } else {
                            return PokeListItem(
                              poke: pokes.byId(itemId(index, favs.favs)),
                            );
                          }
                        },
                      ),
                      onLoad: () {
                        if (!isLastPage(_currentPage, favs.favs.length)) {
                          setState(() => _currentPage++);
                        }
                      },
                    );
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TopHeadMenu extends StatelessWidget {
  const TopHeadMenu({
    Key? key,
    required this.isFavoriteMode,
    required this.changeFavMode,
    required this.isGridMode,
    required this.changeGridMode,
  }) : super(key: key);

  final bool isFavoriteMode;
  final Function(bool) changeFavMode;
  final bool isGridMode;
  final Function(bool) changeGridMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32,
      alignment: Alignment.topRight,
      child: IconButton(
        onPressed: () async {
          await showModalBottomSheet<bool>(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              ),
            ),
            builder: (BuildContext context) {
              return ViewModeBottomSheet(
                favMode: isFavoriteMode,
                changeFavMode: changeFavMode,
                gridMode: isGridMode,
                changeGridMode: changeGridMode,
              );
            },
          );
        },
        padding: const EdgeInsets.all(0),
        icon: isFavoriteMode
            ? const Icon(
                Icons.auto_awesome,
                color: Colors.orangeAccent,
              )
            : const Icon(Icons.auto_awesome_outlined),
      ),
    );
  }
}

class ViewModeBottomSheet extends StatelessWidget {
  const ViewModeBottomSheet({
    Key? key,
    required this.favMode,
    required this.changeFavMode,
    required this.gridMode,
    required this.changeGridMode,
  }) : super(key: key);
  final bool favMode;
  final bool gridMode;
  final Function(bool) changeFavMode;
  final Function(bool) changeGridMode;
  static const String mainText = '表示設定';

  String favTitle(bool fav) {
    if (fav) {
      return '「すべて」表示に切り替え';
    } else {
      return '「お気に入り」表示に切り替え';
    }
  }

  String favSubtitle(bool fav) {
    if (fav) {
      return '全てのポケモンが表示されます';
    } else {
      return 'お気に入りに登録したポケモンのみが表示されます';
    }
  }

  String gridTitle(bool grid) {
    if (grid) {
      return 'リスト表示に切り替え';
    } else {
      return 'グリッド表示に切り替え';
    }
  }

  String gridSubtitle(bool grid) {
    if (grid) {
      return 'ポケモンをリスト表示します';
    } else {
      return 'ポケモンをグリッド表示します';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              height: 5,
              width: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).backgroundColor,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Text(
                mainText,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(
                favTitle(favMode),
              ),
              subtitle: Text(
                favSubtitle(favMode),
              ),
              onTap: () {
                changeFavMode(favMode);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.grid_3x3),
              title: Text(
                gridTitle(gridMode),
              ),
              subtitle: Text(
                gridSubtitle(gridMode),
              ),
              onTap: () {
                changeGridMode(gridMode);
                Navigator.pop(context);
              },
            ),
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              ),
              child: const Text('キャンセル'),
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ),
    );
  }
}
