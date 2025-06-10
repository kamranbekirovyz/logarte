# logarte

In-app debug console and logger for Flutter apps.

## 📦 Features
- 🚀 **In-app console**: Monitor your app inside your app
- 🔒 **Access control**: Optional password protection
- 📡 **Network inspector**: Track API calls and responses
- 📁 **Storage monitor**: Track local storage operations
- 📤 **Copy & export**: Share debug logs with your team

## 📱 Screenshots

|Console|API Request|Password|
|---|---|---|
|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s1.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s2.png?raw=true"/>|<img width="200" src="https://github.com/kamranbekirovyz/logarte/blob/main/res/s3.png?raw=true"/>

## 🩵 Sponsors

Want to say "thanks"? Check out our sponsors:

<a href="https://userorient.com" target="_blank">
	<img src="https://www.userorient.com/assets/extras/sponsor.png">
</a>

## 🪚 Usage

### Add to pubspec.yaml

```yaml
dependencies:
  logarte: ^0.2.1
```

Then run `flutter pub get`.

### Initialize

Create a global `Logarte` instance:

```dart
final Logarte logarte = Logarte(
    // Protect with password
    password: '1234',
    
    // Skip password in debug mode
    ignorePassword: kDebugMode,

    // Share network request
    onShare: (String content) {
      Share.share(content);
    },

    // To have logs in IDE's debug console (default is false)
    disableDebugConsoleLogs: false,

    // Add shortcut actions (optional)
    onRocketLongPressed: (context) {
      // e.g: toggle theme mode
    }
    onRocketDoubleTapped: (context) {
      // e.g: change language
    }
);
```

### Enable the debug console

#### In debug mode

Ideally, you should attach the floating button to the widget tree, then click it to open the debug console. This is the preferred way because you don't know when you'll need it and sometimes you might need to go back and forth many times. So, it's better to have it on the UI always.

```dart
@override
void initState() {
  super.initState();
  
  logarte.attach(
    context: context,
    visible: kDebugMode,
  );
}
```

This will attach the floating button when in debug mode. Curious how you can access it in production when it's not debug mode? Check below.

#### In production

Logarte is as valuable in production mode as it is in debug mode. Whenever you find a bug, notice something not working, API requests failing, etc., you should be able to check the console and find why.

Two ways to access in production:

##### Hidden gesture trigger

`LogarteMagicalTap` is a widget that attaches the floating button to the UI when tapped 10 times. Wrap any non-tappable widget, keep it secret, and make sure you've set a password while initializing.

```dart
LogarteMagicalTap(
  logarte: logarte,
  child: Text('App Version 1.0'),
  onTapCountUpdate: (count) {
     logarte.log('On tap count updated: $count');
  },
)
```

##### Manual trigger

You might also have creative ideas on when and how to open the console. For example, I used a shake detection plugin and attached the floating button when the device was shaken 3 times consecutively. From my experience, this is extremely valuable. Why? Imagine: you've opened your app, went to deeper screens, and an API call failed. You say 'Thank God I've already integrated logarte. Let's open that console!' But you need to go to the page where you used `LogarteMagicalTap`, which might be too far or not visible at that stage of the app - maybe you're showing it on the profile page and you are on the login page. So be creative about where to add it and consider using shake detection or anything that would serve you better.

```dart
logarte.openConsole(context);
```

Different from the `.attach(context)` method, this will directly open the console (password page if set, else the console itself).

### Log network requests

#### With Dio

```dart
dio.interceptors.add(LogarteDioInterceptor(logarte));
```

That's it? Yes, that's it. Now, all the network requests will be logged in both the debug and the graphical console.

#### With other HTTP clients


```dart
// After your HTTP request:
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

```dart
logarte.log('Button clicked');
```

This will log messages in both your IDE's debug console and the in-app logarte console.

### Track navigation

```dart
MaterialApp(
  navigatorObservers: [LogarteNavigatorObserver(logarte)],
)
```

### Track storage operations

```dart
logarte.database(
  target: 'language',
  value: 'en',
  source: 'SharedPreferences',
);
```

### Add custom debug tab

While initializing, you can pass a custom tab widget to the `Logarte` instance. This tab will be shown in the console.

This is useful when you want to add a custom tab to the console, for example, to change the environment, copy device's FCM token, clear local cache, etc.

```dart
final Logarte logarte = Logarte(
  ...
  customTab: const MyCustomTab(),
  ...
);
```


## 🕹️ Example

See the complete [example](https://github.com/kamranbekirovyz/logarte/blob/main/example/lib/main.dart) in this repository.

## 📄 License
MIT License - see [LICENSE](https://github.com/kamranbekirovyz/logarte/blob/main/LICENSE).
