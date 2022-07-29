import 'package:flutter/material.dart';


class ThemeModeSelectionPage extends StatefulWidget {
  const ThemeModeSelectionPage({Key? key, required this.mode,}) : super(key: key);
  final ThemeMode mode;

  @override
  State createState() => _ThemeModeSelectionPage();
}


class _ThemeModeSelectionPage extends State<ThemeModeSelectionPage> {
  late ThemeMode _current;

  @override
  void initState() {
    super.initState();
    _current = widget.mode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              ListTile(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop<ThemeMode>(context, _current),
                ),
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System'),
                value: ThemeMode.system,
                groupValue: _current,
                onChanged: (val) => {
                  setState(() => {
                    _current = val!
                  })
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark'),
                value: ThemeMode.dark,
                groupValue: _current,
                onChanged: (val) => {
                  setState(() => {
                    _current = val!
                  })
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Light'),
                value: ThemeMode.light,
                groupValue: _current,
                onChanged: (val) => {
                  setState(() => {
                    _current = val!
                  })
                },
              )
            ],
          ),
        )
    );
  }
}