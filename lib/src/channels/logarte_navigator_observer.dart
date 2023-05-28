import 'package:flutter/material.dart';
import 'package:logarte/src/logarte.dart';
import 'package:logarte/src/models/navigation_action.dart';

class LogarteNavigatorObserver extends NavigatorObserver {
  final Logarte _logarte;

  LogarteNavigatorObserver(this._logarte);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logarte.logNavigation(
      route: route,
      previousRoute: previousRoute,
      action: NavigationAction.push,
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logarte.logNavigation(
      route: route,
      previousRoute: previousRoute,
      action: NavigationAction.pop,
    );
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logarte.logNavigation(
      route: route,
      previousRoute: previousRoute,
      action: NavigationAction.remove,
    );
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logarte.logNavigation(
      route: newRoute,
      previousRoute: oldRoute,
      action: NavigationAction.replace,
    );
  }
}
