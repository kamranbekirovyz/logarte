import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';

final logarte = Logarte(
  onShare: Share.share,
  password: '1234',
  onRocketDoubleTapped: (context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            'onRocketDoubleTapped',
          ),
          content: Text(
            'This callback is useful when you want to quickly access some pages or perform actions without leaving the currently page (toggle theme, change language and etc.).',
          ),
        );
      },
    );
  },
  onRocketLongPressed: (context) {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text(
            'onRocketLongPressed',
          ),
          content: Text(
            'This callback is useful when you want to quickly access some pages or perform actions without leaving the currently page (toggle theme, change language and etc.).',
          ),
        );
      },
    );
  },
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
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blueGrey.shade900,
      ),
      navigatorObservers: [
        LogarteNavigatorObserver(logarte),
      ],
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
  late final Dio _dio;

  @override
  void initState() {
    super.initState();

    _dio = Dio()
      ..interceptors.add(
        LogarteDioInterceptor(logarte),
      );

    logarte.attach(
      context: context,
      visible: false,
    );
  }

  @override
  void dispose() {
    _dio.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      body: Column(
        children: [
          LogarteMagicalTap(
            logarte: logarte,
            child: Container(
              color: Colors.blueGrey.shade100,
              child: const ListTile(
                enabled: true,
                leading: Icon(Icons.touch_app_rounded),
                title: Text('LogarteMagicalTap'),
                subtitle: Text(
                  'Tap this widget 10 times to attach the logarte rocket button UI.',
                ),
              ),
            ),
          ),
          const Divider(),
          ButtonBar(
            children: [
              FilledButton.tonal(
                onPressed: () async {
                  await _dio.get('https://jsonplaceholder.typicode.com/posts');
                },
                child: const Text('GET'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  await _dio.post('https://jsonplaceholder.typicode.com/posts');
                },
                child: const Text('POST'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  await _dio.put('https://jsonplaceholder.typicode.com/posts');
                },
                child: const Text('PUT'),
              ),
              FilledButton.tonal(
                onPressed: () async {
                  await _dio
                      .delete('https://jsonplaceholder.typicode.com/posts');
                },
                child: const Text('DELETE'),
              ),
            ],
          ),
          const Divider(),
          OverflowBar(
            children: [
              FilledButton.tonal(
                onPressed: () {
                  logarte.database(
                    target: 'language',
                    value: 'en',
                    source: 'SharedPreferences',
                  );
                },
                child: const Text('Write to database'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    routeSettings: const RouteSettings(
                      name: '/test-dialog',
                    ),
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        title: Text('Dialog'),
                        content: Text(
                          'Opening of this dialog was logged to Logarte',
                        ),
                      );
                    },
                  );
                },
                child: const Text('Open dialog'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  try {
                    throw Exception('Exception');
                  } catch (e, s) {
                    logarte.error(e, stackTrace: s);
                  }
                },
                child: const Text('Exception'),
              ),
              FilledButton.tonal(
                onPressed: () {
                  logarte.info('Printed to console');
                },
                child: const Text('Plain log'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
