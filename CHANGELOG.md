# 1.4.0

* Added `onExport` parameter to the `Logarte` instance to export all logs as a shareable text. Your QA will think you are a wizard!
* Improved the network entry shareable text too.

# 1.3.0

* Redesigned the `AppBar` of the console dashboard for more breathing space.
* Added clear all logs button as an action in the `AppBar`.

# 1.2.2

* Added "Show more" & "Show less" button for logs with more than 5 lines. Thanks to [@Captured-Heart](https://github.com/Captured-Heart) for the feature request!

# 1.2.1

* Fixed scrolling exceptions on desktop platforms. Thanks to [@karelklic](https://github.com/karelklic) for the contribution!

# 1.2.0

* Added "Copy cURL" to the network log entry details screen.

## 1.1.0

* Added back button to the console when it was launched without the floating button. Thanks community!
* Update dio dependency version range to ensure compatibility.

## 1.0.0

* Hitting first stable release! 🎉 Logarte is now "readier" for production use.
* Fixed a bug where clicking floating button in network details page would stuck the console.

## 0.3.1

* Added `disableDebugConsoleLogs` parameter to disable logs in IDE's debug console (default is false).

## 0.3.0

* You can now pass a custom tab to the console.

## 0.2.4

* Improve database log's format and fix overflow issue on console.

## 0.2.3

* Fix stack trace not being shown on logs.

## 0.2.2

* You can now drag the entry button to anywhere on the screen with edge snapping behavior.

## 0.2.1

* Simplified the docs.

## 0.2.0

* Simplify the logging method.
* Deprecated `logarte.info()` and `logarte.error()` methods. Use `logarte.log()` instead.
* Upgrade dependencies.
* Update example project.

## 0.1.6

* Fix images not being displayed in the documentation.

## 0.1.5

* Some improvements in the documentation.

## 0.1.4

* Fix links in the documentation.

## 0.1.3

* Added documentation for the package to release it on pub.dev.
* Upgrade dependencies to the latest versions.

## 0.1.2

* Added `LogarteMagicalTap` widget which tapped N times in a row will attach logarte to the screen.
* Implemented search functionality and improved overall interface of the console.

## 0.1.1

* Added `Logarte#onRocketLongPressed` and `Logarte#onRocketDoubleTapped` parameters and initial version of console logger.

## 0.1.0

* Initial release with `LogarteNavigatorObserver`, `LogarteDioInterceptor` and console as a graphical user interface.