import 'package:flutter/cupertino.dart';
import 'package:pokemon_flutter/models/pokemon.dart';

class PokeAbout extends StatelessWidget {
  const PokeAbout({Key? key, required this.poke, required this.fontColor}) : super(key: key);
  final Pokemon poke;
  final Color fontColor;

  Widget _rowBuilder(String text, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: fontColor,
              ),
            ),
          ),
          const SizedBox(
            width: 25,
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 36, 36, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _rowBuilder('分類', poke.species),
                _rowBuilder('高さ', '${poke.height} m'),
                _rowBuilder('重さ', '${poke.weight} kg'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
