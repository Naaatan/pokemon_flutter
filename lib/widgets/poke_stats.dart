import 'package:flutter/material.dart';
import 'package:pokemon_flutter/const/pokeapi.dart';
import 'package:pokemon_flutter/models/pokemon.dart';

class PokeStats extends StatelessWidget {
  const PokeStats({Key? key, required this.poke, required this.fontColor}) : super(key: key);
  final Pokemon poke;
  final Color fontColor;

  double _convertHpValue(int value) {
    var dValue = value.toDouble();
    return dValue * (1.0 / 255.0);
  }

  double _convertOtherStatsValue(int value) {
    var dValue = value.toDouble();
    return dValue * (1.0 / 250.0);
  }

  Widget _statsBar(String label, String valueLabel, double value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: fontColor,
            ),
          ),
          const Spacer(),
          Text(
            valueLabel,
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 14,
              color: fontColor,
            ),
          ),
          Container(
            width: 250,
            height: 10,
            margin: const EdgeInsets.only(left: 16),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: pokeTypeColors[poke.types.first]?.withOpacity(.3),
                valueColor: AlwaysStoppedAnimation<Color>(pokeTypeColors[poke.types.first] ?? Colors.blueGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 36, 24, 0),
      child: Column(
        children: [
          _statsBar('HP', poke.hp.toString(), _convertHpValue(poke.hp)),
          _statsBar('攻撃', poke.attack.toString(), _convertOtherStatsValue(poke.attack)),
          _statsBar('防御', poke.defense.toString(), _convertOtherStatsValue(poke.defense)),
          _statsBar('特攻', poke.spAttack.toString(), _convertOtherStatsValue(poke.spAttack)),
          _statsBar('特防', poke.spDefense.toString(), _convertOtherStatsValue(poke.spDefense)),
          _statsBar('素早さ', poke.speed.toString(), _convertOtherStatsValue(poke.speed))
        ],
      ),
    );
  }
}
