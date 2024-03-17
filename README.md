# logarte

A magical graphical debug console for Flutter.

<img src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/cover.png?raw=true">

## 📦 Features
- 🚀 **Graphical Console**: a beautiful graphical console for debugging.
- 🔒 **Password Protection**: add password protection to graphical console.
- 📡 **Network Requests**: see network requests, responses, status code and size.
- 📁 **Database Writes**: see database write transactions and their content.
- 📤 **Share Logs**: share all kinds of logs with platform share window.

## 🪚 Installation

To use this package, add `logarte` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  logarte: -latest_version-
```

Then, run `flutter pub get` in your terminal to install the package.

## 🚀 Usage

### Create an instance

You'll need a `Logarte` instance throughout the app. I, personally, prefer to store a global instance of `Logarte` in a separate file. Here is an example of how to create a `Logarte` instance:

```dart
final Logarte logarte = Logarte(
    // Password for protecting the console
    password: '1234',

    // Whether to ignore the password, helpful to ignore password in debug mode
    ignorePassword: false,

    // When share button is pressed, this callback will be called
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

The `Logarte` console can be opened by two methods: using the entry rocket button or using `LogarteMagicalTap` which is a `GestureDetector` that opens the console when tapped 10 times.

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

`LogarteMagicalTap` is a widget that attaches the entry rocket button when tapped 10 times. Wrap any non-tappable widget, and keep it secret.

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