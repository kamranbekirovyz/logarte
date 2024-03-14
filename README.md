# logarte

A magical graphical debug console for Flutter.

<img src="https://github.com/kamranbekirovyz/logarte/blob/main/doc/cover.png?raw=true">

## 📦 Features
- **Password Protection**: Protect your graphical debug console with a password.
- **Entry Button**: A floating button that can be used to open the console from anywhere in the app.
- **Share Logs**: Share logs, even the network requests, with a single tap.

## ⚠️ Work in Progress

Hey, I'm <a href="https://kamranbekirov.com">Kamran</a> and I've been both developing and using this package for almost a year now. I've been using it in my personal projects and I've been improving it over time. I've decided to open-source it and share it with the community. I'm planning to add more features and improve the package over time. If you have any suggestions or ideas, feel free to open an issue or a pull request.

Here are some of the features that I'm planning to add in the very near future:
- Floating logarte console entry button (the rocket button)
- Ability to customize the style of print messages on debug console

## 🪚 Installation

To use this package, add `logarte` as a dependency in your `pubspec.yaml` file:

```yaml
dependencies:
  logarte: -latest_version-
```

Then, run `flutter pub get` in your terminal to install the package.

## 🚀 Usage

### Create an instance

You'll need a `Logarte` instance throughout the app. I, personally, prefer to store a global instance of `Logarte` in a separate file and use it throughout the app. Here is an example of how to create a `Logarte` instance:

```dart
final Logarte logarte = Logarte(
    password: '1234',
    ignorePassword: false,
    onShare: (String message) {
      Share.share(message);
    },
    onRocketLongPressed: (BuildContext context) {
        // Ideas: toggle theme mode, reset app state, clear local storage, etc.

        print('Rocket long pressed');
    },
    onRocketDoubleTapped: (BuildContext context) {
        // Ideas: change app language, open some hidden settings page, etc.

        print('Rocket double tapped');
    },
);
```

### Open the console

The `Logarte` console can be opened by two methods: using the rocket entry button or using `LogarteMagicalTap` which is a `GestureDetector` that opens the console when tapped 10 times.

#### Rocket Entry Button

It's a floating button that can be used to open the console from anywhere in the app. You simply attach it to the UI and it will be visible on top of everything and add a boolean to the `attach` method to make it visible only in debug mode, or when the environment is Dev and etc.

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

`LogarteMagicalTap` is a widget that attaches the rocket button mentioned above when it is tapped 10 times.

```dart
LogarteMagicalTap(
  logarte: logarte,
  child: Text(
    'LibroKit v1.0.0, Developed by Kamran Bekirov',
  ),
)
```

### Track Network Requests

You can track network requests by either using `LogarteDioInterceptor` for Dio or the custom method for other clients.

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

## 🕹️ Example

For a more detailed example, check the <a href="https://github.com/kamranbekirovyz/logarte/blob/main/example/lib/main.dart" target="_blank">example</a> directory in this repository.

## 📄 License
This package is open-source and released under the <a href="https://github.com/kamranbekirovyz/logarte/blob/main/LICENSE" target="_blank">MIT License</a>.