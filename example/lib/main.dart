import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';

final logarte = Logarte(
  onShare: Share.share,
  consolePassword: 'logarte',
);

enum Environment { dev, staging, prod }

const environment = Environment.dev;

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Logarte Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey.shade900,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    logarte.attachBackDoorButtonOverlay(
      context: context,
      visible: environment == Environment.dev ||
          environment == Environment.staging ||
          kDebugMode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text(
          'Logarte Example',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
