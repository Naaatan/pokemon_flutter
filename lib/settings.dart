import 'package:flutter/material.dart';
import 'package:pokemon_flutter/models/theme_mode.dart';
import 'package:pokemon_flutter/theme_mode_selection.dart';
import 'package:provider/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State createState() => _SettingsState();
}


class _SettingsState extends State<Settings> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeNotifier>(
      builder: (context, mode, child) => ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.lightbulb),
            title: const Text('Dark/Light Mode'),
            trailing: Text((mode.mode == ThemeMode.system
                ? 'System'
                : (mode.mode == ThemeMode.dark) ? 'Dark' : 'Light')),
            onTap: () async {
              final ret = await Navigator.of(context).push<ThemeMode>(
                  MaterialPageRoute(
                      builder: (context) => ThemeModeSelectionPage(mode: mode.mode)
                  )
              );

              if (ret != null) {
                mode.update(ret);
              }
            },
          ),
        ],
      ),
    );
  }
}
