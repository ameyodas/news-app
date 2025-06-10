import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:news_app/pages/interests_page.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const darkTheme = SettingsThemeData(
      settingsListBackground: Colors.black,
      settingsSectionBackground: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: SettingsList(
            darkTheme: darkTheme,
            sections: [
              SettingsSection(
                title: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Text('Settings',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Raleway',
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                tiles: [
                  SettingsTile(
                    title: const Text('Account',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.person_12_regular),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AccountSettingsPage()),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Language',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.local_language_16_filled),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const LanguageSettingsPage()),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Appearance',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.color_24_filled),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AppearanceSettingsPage()),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Interests',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.heart_12_regular),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const InterestsPage()),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Home',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.home_12_regular),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomeSettingsPage()),
                    ),
                  ),
                  SettingsTile(
                    title: const Text('Reading Page',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                        )),
                    leading: const Icon(FluentIcons.reading_list_16_filled),
                    onPressed: (context) => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ReadingSettingsPage()),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Detail pages each manage their own SharedPreferences and UI

class AccountSettingsPage extends StatefulWidget {
  const AccountSettingsPage({super.key});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  @override
  Widget build(BuildContext context) {
    const darkTheme = SettingsThemeData(
      settingsListBackground: Colors.black,
      settingsSectionBackground: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded, size: 20.0),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )),
      ),
      body: SettingsList(
        darkTheme: darkTheme,
        sections: [
          SettingsSection(
            title: const Text('Account',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Raleway',
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                )),
            tiles: [
              SettingsTile(
                title: const Text('Manage Credentials'),
                leading: const Icon(FluentIcons.key_24_filled),
                onPressed: (context) {},
              ),
              SettingsTile(
                title: const Text('Sign Out'),
                leading: const Icon(FluentIcons.arrow_exit_20_filled),
                onPressed: (context) {},
              ),
              SettingsTile(
                title: const Text('Delete Account'),
                leading: const Icon(FluentIcons.delete_12_filled),
                onPressed: (context) {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  State<LanguageSettingsPage> createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  late SharedPreferences _prefs;
  String _language = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Tamil', 'Telugu'];
  static const _keyLanguage = 'language';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      setState(() {
        _language = _prefs.getString(_keyLanguage) ?? _languages.first;
      });
    });
  }

  void _setLanguage(String? lang) {
    if (lang != null) {
      _prefs.setString(_keyLanguage, lang);
      setState(() => _language = lang);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Default Language'),
            tiles: [
              SettingsTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                trailing: DropdownButton<String>(
                  value: _language,
                  underline: const SizedBox(),
                  onChanged: _setLanguage,
                  items: _languages
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppearanceSettingsPage extends StatefulWidget {
  const AppearanceSettingsPage({super.key});

  @override
  State<AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<AppearanceSettingsPage> {
  late SharedPreferences _prefs;
  bool _darkMode = false;
  String _fontSize = 'Medium';
  final List<String> _fontSizes = ['Small', 'Medium', 'Large'];
  static const _keyDark = 'dark_mode';
  static const _keyFontSize = 'font_size';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      setState(() {
        _darkMode = _prefs.getBool(_keyDark) ?? false;
        _fontSize = _prefs.getString(_keyFontSize) ?? 'Medium';
      });
    });
  }

  void _toggleDark(bool v) {
    _prefs.setBool(_keyDark, v);
    setState(() => _darkMode = v);
  }

  void _setFontSize(String? size) {
    if (size != null) {
      _prefs.setString(_keyFontSize, size);
      setState(() => _fontSize = size);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Appearance Settings'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Dark Mode'),
                leading: const Icon(Icons.brightness_6),
                initialValue: _darkMode,
                onToggle: _toggleDark,
              ),
              SettingsTile(
                title: const Text('Font Size'),
                leading: const Icon(Icons.font_download),
                trailing: DropdownButton<String>(
                  value: _fontSize,
                  underline: const SizedBox(),
                  onChanged: _setFontSize,
                  items: _fontSizes
                      .map((f) => DropdownMenuItem(value: f, child: Text(f)))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class HomeSettingsPage extends StatefulWidget {
  const HomeSettingsPage({super.key});

  @override
  State<HomeSettingsPage> createState() => _HomeSettingsPageState();
}

class _HomeSettingsPageState extends State<HomeSettingsPage> {
  late SharedPreferences _prefs;
  bool _autoLoad = true;
  String _layout = 'Grid';
  final List<String> _layouts = ['Grid', 'List'];
  static const _keyAuto = 'auto_load_home';
  static const _keyLayout = 'home_layout';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      setState(() {
        _autoLoad = _prefs.getBool(_keyAuto) ?? true;
        _layout = _prefs.getString(_keyLayout) ?? 'Grid';
      });
    });
  }

  void _toggleAuto(bool v) {
    _prefs.setBool(_keyAuto, v);
    setState(() => _autoLoad = v);
  }

  void _setLayout(String? l) {
    if (l != null) {
      _prefs.setString(_keyLayout, l);
      setState(() => _layout = l);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Home Settings'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Auto-load Feed'),
                leading: const Icon(Icons.autorenew),
                initialValue: _autoLoad,
                onToggle: _toggleAuto,
              ),
              SettingsTile(
                title: const Text('Layout'),
                leading: const Icon(Icons.view_agenda),
                trailing: DropdownButton<String>(
                  value: _layout,
                  underline: const SizedBox(),
                  onChanged: _setLayout,
                  items: _layouts
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ReadingSettingsPage extends StatefulWidget {
  const ReadingSettingsPage({super.key});

  @override
  State<ReadingSettingsPage> createState() => _ReadingSettingsPageState();
}

class _ReadingSettingsPageState extends State<ReadingSettingsPage> {
  late SharedPreferences _prefs;
  bool _summarize = false;
  bool _translate = false;
  bool _swipe = true;
  bool _showImg = true;
  static const _keySumm = 'summarize_default';
  static const _keyTrans = 'translate_default';
  static const _keySwipe = 'swipe_next';
  static const _keyImg = 'show_image';

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((p) {
      _prefs = p;
      setState(() {
        _summarize = _prefs.getBool(_keySumm) ?? false;
        _translate = _prefs.getBool(_keyTrans) ?? false;
        _swipe = _prefs.getBool(_keySwipe) ?? true;
        _showImg = _prefs.getBool(_keyImg) ?? true;
      });
    });
  }

  void _toggle(String key, bool val) {
    _prefs.setBool(key, val);
    setState(() {
      switch (key) {
        case _keySumm:
          _summarize = val;
          break;
        case _keyTrans:
          _translate = val;
          break;
        case _keySwipe:
          _swipe = val;
          break;
        case _keyImg:
          _showImg = val;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const themeData = SettingsThemeData(
      settingsSectionBackground: Colors.black,
      settingsListBackground: Colors.black,
    );
    return Scaffold(
      appBar: AppBar(title: const Text('Reading Page')),
      body: SettingsList(
        darkTheme: themeData,
        sections: [
          SettingsSection(
            title: const Text('Reading Page Settings'),
            tiles: [
              SettingsTile.switchTile(
                title: const Text('Summarize by default'),
                leading: const Icon(FluentIcons.filter_12_filled),
                initialValue: _summarize,
                onToggle: (v) => _toggle(_keySumm, v),
              ),
              SettingsTile.switchTile(
                title: const Text('Translate by default'),
                leading: const Icon(FluentIcons.translate_16_filled),
                initialValue: _translate,
                onToggle: (v) => _toggle(_keyTrans, v),
              ),
              SettingsTile.switchTile(
                title: const Text('Swipe to next article'),
                leading: const Icon(Icons.swipe),
                initialValue: _swipe,
                onToggle: (v) => _toggle(_keySwipe, v),
              ),
              SettingsTile.switchTile(
                title: const Text('Show images'),
                leading: const Icon(Icons.image),
                initialValue: _showImg,
                onToggle: (v) => _toggle(_keyImg, v),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Placeholder pages
class AccountCredentialsPage extends StatelessWidget {
  const AccountCredentialsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Manage Credentials')),
        body: const Center(child: Text('Credentials Settings')),
      );
}

// class InterestsPage extends StatelessWidget {
//   const InterestsPage({super.key});
//   @override
//   Widget build(BuildContext context) => Scaffold(
//         appBar: AppBar(title: const Text('Edit Interests')),
//         body: const Center(child: Text('Interests Settings')),
//       );
// }
