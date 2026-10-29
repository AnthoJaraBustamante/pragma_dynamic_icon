import 'package:dynamic_app_icon_flutter_plus/dynamic_app_icon_flutter_plus.dart';
import 'package:flutter/material.dart';

import 'icon_selector_page.dart';

void main() {
  runApp(const PragmaDynamicIconApp());
}

class PragmaDynamicIconApp extends StatefulWidget {
  const PragmaDynamicIconApp({super.key});

  @override
  State<PragmaDynamicIconApp> createState() => _PragmaDynamicIconAppState();
}

class _PragmaDynamicIconAppState extends State<PragmaDynamicIconApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      DynamicAppIconFlutterPlus.applyPendingIcon();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pragma Dynamic Icon',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7490),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0E7490),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const IconSelectorPage(),
    );
  }
}
