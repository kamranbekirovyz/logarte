import 'package:flutter/widgets.dart';

extension LogarteRouteXs on Route? {
  String get routeInfo {
    if (this == null) {
      return 'Route is null';
    }

    final routeName = this!.settings.name;
    final routeArgs = this!.settings.arguments;

    final routeInfo = StringBuffer();
    routeInfo.write('name: $routeName');

    if (routeArgs != null) {
      routeInfo.write(', args: $routeArgs');
    }

    return routeInfo.toString();
  }
}
