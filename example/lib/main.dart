import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:share_plus/share_plus.dart';

final Logarte logarte = Logarte(
  onShare: Share.share,
  password: '1234',
  customTab: const MyCustomTab(),
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
  // isAppBarSticky: true, uncomment to enable sticky app bar
);

enum Environment { dev, prod }

const Environment environment = Environment.dev;

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
        title: const Text('Logarte Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            LogarteMagicalTap(
              logarte: logarte,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const ListTile(
                  leading: Icon(Icons.touch_app_rounded),
                  title: Text('LogarteMagicalTap'),
                  subtitle: Text(
                    'Tap 10 times to attach the magical button.',
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard_outlined),
              title: const Text('Logarte console'),
              subtitle: const Text(
                'Tap to open the console directly.',
              ),
              onTap: () {
                logarte.openConsole(context);
              },
            ),
            const Divider(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HTTP Requests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                FilledButton.tonal(
                  onPressed: () async {
                    await _dio.get(
                        'https://jsonplaceholder.typicode.com/posts?query=123&query2=456&query3=789');
                  },
                  child: const Text('GET'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    await _dio
                        .post('https://jsonplaceholder.typicode.com/posts');
                  },
                  child: const Text('POST'),
                ),
                FilledButton.tonal(
                  onPressed: () async {
                    await _dio
                        .put('https://jsonplaceholder.typicode.com/posts');
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
            const Divider(
              height: 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Other logs',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                FilledButton.tonalIcon(
                  onPressed: () {
                    logarte.database(
                      target: 'language',
                      value: 'en',
                      source: 'SharedPreferences',
                    );
                  },
                  label: const Text('Write to database'),
                  icon: const Icon(Icons.storage_outlined),
                ),
                FilledButton.tonalIcon(
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
                  label: const Text('Open dialog'),
                  icon: const Icon(Icons.open_in_new),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    try {
                      throw Exception('Exception');
                    } catch (e, s) {
                      logarte.log(e, stackTrace: s);
                    }
                  },
                  label: const Text('Exception'),
                  icon: const Icon(Icons.error_outline),
                ),
                FilledButton.tonalIcon(
                  onPressed: () {
                    logarte.log('Printed to console');
                  },
                  label: const Text('Plain log'),
                  icon: const Icon(Icons.print_outlined),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MyCustomTab extends StatefulWidget {
  const MyCustomTab({super.key});

  @override
  State<MyCustomTab> createState() => _MyCustomTabState();
}

class _MyCustomTabState extends State<MyCustomTab> {
  Environment _environment = environment;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Environment'),
            trailing: DropdownButton<Environment>(
              padding: EdgeInsets.zero,
              value: _environment,
              onChanged: (value) {
                setState(() {
                  _environment = value!;
                });
              },
              items: Environment.values.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e.name.toUpperCase()),
                );
              }).toList(),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.notifications_outlined),
            title: const Text('FCM token'),
            subtitle: const Text(
              'dJkH8Hs9_dKpQm2nLxY:APA91bGj8g_QxL3xJ2K9pQm2nLxYdJkH8Hs9_dKpQm2nLxY',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Copy'),
            ),
          ),

          // Cache size and clear button
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.storage_outlined),
            title: const Text('Local cache'),
            subtitle: const Text('100 MB'),
            trailing: TextButton(
              onPressed: () {},
              child: const Text('Clear All'),
            ),
          ),

          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: 'https://api.example.com/v3/',
            ),
            decoration: const InputDecoration(
              labelText: 'API URL',
              filled: true,
            ),
          ),
        ],
      ),
    );
  }
}
