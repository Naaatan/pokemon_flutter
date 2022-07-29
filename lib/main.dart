import 'package:flutter/material.dart';
import 'package:pokemon_flutter/models/favorite.dart';
import 'package:pokemon_flutter/models/pokemon.dart';
import 'package:pokemon_flutter/models/theme_mode.dart';
import 'package:pokemon_flutter/poke_list.dart';
import 'package:pokemon_flutter/settings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/theme_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences pref = await SharedPreferences.getInstance();
  final themeModeNotifier = ThemeModeNotifier(pref: pref);
  final pokemonsNotifier = PokemonsNotifier();
  final favoriteNotifier = FavoriteNotifier();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => themeModeNotifier,
        ),
        ChangeNotifierProvider(
          create: (context) => pokemonsNotifier,
        ),
        ChangeNotifierProvider(
          create: (context) => favoriteNotifier,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pokemon Flutter',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: mode.mode,
        home: const TopPage(),
      ),
    );
  }
}

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  int currentbnb = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          children: const [PokeList(), Settings()],
          index: currentbnb,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => {setState(() => currentbnb = index)},
        currentIndex: currentbnb,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'settings')
        ],
      ),
    );
  }
}
