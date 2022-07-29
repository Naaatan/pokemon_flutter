import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_flutter/const/pokeapi.dart';
import 'package:pokemon_flutter/models/favorite.dart';
import 'package:pokemon_flutter/widgets/poke_about.dart';
import 'package:pokemon_flutter/widgets/poke_stats.dart';
import 'package:provider/provider.dart';

import 'models/pokemon.dart';

class PokeDetail extends StatefulWidget {
  const PokeDetail({Key? key, required this.poke}) : super(key: key);
  final Pokemon poke;

  @override
  State<PokeDetail> createState() => _PokeDetailState();
}

class _PokeDetailState extends State<PokeDetail> {
  int _selectedIndex = 0;

  Color _luminanceTextColor(String type) {
    return (pokeTypeColors[type] ?? Colors.grey).computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Widget _buttonBuilder(Pokemon poke, String title, int myIndex) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = myIndex;
        });
      },
      child: Container(
        height: 34,
        width: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: _selectedIndex == myIndex ? pokeTypeColors[widget.poke.types.first] : Colors.grey[300],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              title,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.button?.fontSize ?? 16,
                fontWeight: _selectedIndex == myIndex ? FontWeight.bold : FontWeight.normal,
                color: _selectedIndex == myIndex ? _luminanceTextColor(widget.poke.types.first) : Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteNotifier>(
      builder: (context, favs, child) {
        return Scaffold(
          body: Container(
            color: (pokeTypeColors[widget.poke.types.first] ?? Colors.grey[100])?.withOpacity(.5),
            child: SafeArea(
              bottom: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                    trailing: IconButton(
                      icon: favs.isExist(widget.poke.id)
                          ? const Icon(Icons.star, color: Colors.orangeAccent)
                          : const Icon(Icons.star_outline),
                      onPressed: () => {favs.toggle(Favorite(pokeId: widget.poke.id))},
                    ),
                  ),
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(180),
                            color: Colors.white.withOpacity(.5),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Hero(
                          tag: widget.poke.name,
                          child: CachedNetworkImage(
                            imageUrl: widget.poke.imageUrl,
                            height: 170,
                            width: 170,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      color: Colors.white.withOpacity(.5),
                    ),
                    child: Text(
                      '#${widget.poke.id.toString().padLeft(3, "0")}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      '${widget.poke.name.substring(0, 1).toUpperCase()}${widget.poke.name.substring(1)}',
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: widget.poke.types
                        .map((type) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: Chip(
                                backgroundColor: pokeTypeColors[type] ?? Colors.grey,
                                label: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      pokeTypeIcons[type] ?? "",
                                      style: TextStyle(
                                        fontFamily: 'PokeGoTypes',
                                        color: _luminanceTextColor(type),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      type,
                                      style: TextStyle(
                                        color: _luminanceTextColor(type),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 24),
                    child: Text(
                      widget.poke.description,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(.4),
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(24),
                              topLeft: Radius.circular(24),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buttonBuilder(widget.poke, 'データ', 0),
                            _buttonBuilder(widget.poke, 'ステータス', 1),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 32, bottom: 32),
                          child: _selectedIndex == 0
                              ? PokeAbout(
                                  poke: widget.poke,
                                  fontColor: Theme.of(context).textTheme.bodyText1?.color ?? Colors.white,
                                )
                              : _selectedIndex == 1
                                  ? PokeStats(
                                      poke: widget.poke,
                                      fontColor: Theme.of(context).textTheme.bodyText1?.color ?? Colors.white,
                                    )
                                  : const Spacer(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
