# logarte

In-app debug console and logger for Flutter to monitor the app on-air.

<img src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/cover.png?raw=true">

## 📦 Features
- 🚀 **Graphical Console**: a beautiful graphical console for debugging.
- 🔒 **Password Protection**: add password protection to graphical console.
- 📡 **Network Requests**: see network requests, responses, status code and size.
- 📁 **Database Writes**: see database write transactions and their content.
- 📤 **Share Logs**: share all kinds of logs with platform share window.

## 📱 Screenshots

|Dashboard|Request Details|Password Protection|
|---|---|---|
|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/s1.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/s2.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/s3.png?raw=true"/>

## 👋🏻 Words from the author 

Hi, I'm <a href="https://bio.kamranbekirov.com">Kamran</a>. I've been using this package for a while in the projects I work on. It's a simple and great tool and if you ever need help with it, join my <a href="https://t.me/flutterporelarte" target="_blank">Telegram</a> channel or create an <a href="https://github.com/kamranbekirovyz/logarte/issues" target="_blank">issue</a>.

## 🪚 Installation

To use this package, add `logarte` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  logarte: -latest_version-
```

Then, run `flutter pub get` in your terminal to install the package.

## 🚀 Usage

### Initialize

You'll need a `Logarte` instance throughout the app. I, personally, prefer to store a global instance of `Logarte` in a separate file.

```dart
final Logarte logarte = Logarte(
    // Password for protecting the console
    password: '1234',

    // Whether to ignore the password
    ignorePassword: !kReleaseMode,

    // Sharing the network request log with system share window
    onShare: (String message) {
      Share.share(message);
    },

    // Action to be performed when the rocket button is long pressed
    onRocketLongPressed: (BuildContext context) {
        // Example: toggle theme mode

        print('Rocket long pressed');
    },

    // Action to be performed when the rocket button is double tapped
    onRocketDoubleTapped: (BuildContext context) {
        // Example: switch between languages

        print('Rocket double tapped');
    },
);
```

### Open the console

The `Logarte` console can be opened by two methods: clikcing the entry rocket button or using `LogarteMagicalTap` which opens the console when tapped 10 times.

#### Rocket Entry Button

It's a floating button that can be used to open the console from anywhere in the app. You simply attach it to the UI and it will be visible on top of everything. Add a boolean to the `attach` method to make it visible only in debug mode, or in any other condition.

```dart
@override
void initState() {
  super.initState();

  logarte.attach(
    context: context,
    visilble: !kReleaseMode,
  );
}
```

#### LogarteMagicalTap

`LogarteMagicalTap` is a widget that attaches the entry rocket button to the UI when tapped 10 times. Wrap any non-tappable widget, and keep it secret.

```dart
LogarteMagicalTap(
  logarte: logarte,
  child: Text(
    'LibroKit v2.2',
  ),
)
```

### Track Network Requests

You can track network requests by either using `LogarteDioInterceptor` for `Dio` or the custom method for other clients.

#### Dio

```dart
_dio = Dio()
  ..interceptors.add(
    LogarteDioInterceptor(logarte),
  );
```

That's it? Yes, that's it. Now, all the network requests will be logged in both the debug and the graphical console.

#### Other Clients

```dart
import 'package:http/http.dart' as http;

final body = {
  'name': 'Kamran',
  'age': 22,
};
final headers = {
  'Content-Type': 'application/json',
};
final endpoint = 'https://api.example.com';

final response = await http.post(
  Uri.parse(endpoint),
  headers: headers,
  body: jsonEncode(body),
);

logarte.network(
  request: NetworkRequestLogarteEntry(
    method: 'POST',
    url: endpoint,
    headers: headers,
    body: body,
  ),
  response: NetworkResponseLogarteEntry(
    statusCode: response.statusCode,
    headers: response.headers,
    body: response.body,
  ),
);
```

### Log messages

You can log messages to the console using the `info` method of the `Logarte` instance and then see them in the graphical console.

```dart
logarte.info('This is an info message');
```

I'll add more methods for different log types in the future.

### Track Navigator Routes

To track the navigator routes, you can add `LogarteNavigatorObserver` to the `MaterialApp`'s `navigatorObservers` list.

```dart
MaterialApp(
  navigatorObservers: [
    LogarteNavigatorObserver(logarte),
  ],
)
```

### Track Database Writes

To track database writes, you can use the `database` method of the `Logarte` instance.

```dart
logarte.database(
  target: 'language',
  value: 'en',
  source: 'SharedPreferences',
);
```

## 🕹️ Example

For a more detailed example, check the <a href="https://github.com/kamranbekirovyz/logarte/blob/main/example/lib/main.dart" target="_blank">example</a> directory in this repository.

## 📄 License
This package is open-source and released under the <a href="https://github.com/kamranbekirovyz/logarte/blob/main/LICENSE" target="_blank">MIT License</a>.