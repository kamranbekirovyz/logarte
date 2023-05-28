import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';
import 'package:logarte/src/extensions/entry_extensions.dart';
import 'package:logarte/src/extensions/route_extensions.dart';
import 'package:logarte/src/extensions/string_extensions.dart';
import 'package:logarte/src/models/navigation_action.dart';

class LogarteEntryItem extends StatelessWidget {
  final LogarteEntry entry;
  final Logarte instance;

  const LogarteEntryItem(
    this.entry, {
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entry is NetworkLogarteEntry) {
      return _NetworkItem(
        entry: entry as NetworkLogarteEntry,
        instance: instance,
      );
    } else if (entry is PlainLogarteEntry) {
      return _PlainItem(
        entry: entry as PlainLogarteEntry,
      );
    } else if (entry is DatabaseLogarteEntry) {
      return _DatabaseItem(
        entry: entry as DatabaseLogarteEntry,
      );
    } else if (entry is NavigatorLogarteEntry) {
      return _NavigationItem(
        entry: entry as NavigatorLogarteEntry,
      );
    } else {
      return const FlutterLogo();
    }
  }
}

class _PlainItem extends StatelessWidget {
  final PlainLogarteEntry entry;

  const _PlainItem({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.bug_report,
      ),
      title: entry.source != null
          ? Text(
              entry.source!,
              style: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w600,
              ),
            )
          : null,
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.message,
            style: const TextStyle(fontSize: 14.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              entry.timeFormatted,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final NavigatorLogarteEntry entry;

  const _NavigationItem({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final from = entry.previousRoute != null
        ? 'From: ${entry.previousRoute.routeInfo}\n'
        : '';
    final to = entry.route != null ? 'To: ${entry.route.routeInfo}' : '';

    return ListTile(
      leading: Icon(
        entry.action == NavigationAction.push
            ? Icons.arrow_forward
            : entry.action == NavigationAction.pop
                ? Icons.arrow_back
                : entry.action == NavigationAction.replace
                    ? Icons.swap_horiz
                    : Icons.remove,
        color: entry.action == NavigationAction.push
            ? Colors.green
            : entry.action == NavigationAction.pop
                ? Colors.red
                : Colors.grey,
      ),
      title: Text(
        entry.action.name.toUpperCase(),
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$from$to',
            style: const TextStyle(fontSize: 14.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              entry.timeFormatted,
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkItem extends StatelessWidget {
  final NetworkLogarteEntry entry;
  final Logarte instance;

  const _NetworkItem({
    Key? key,
    required this.entry,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NetworkLogEntryDetailsScreen(
              entry,
              instance: instance,
            ),
            settings: const RouteSettings(name: '/logarte_entry_details'),
          ),
        );
      },
      leading: Icon(
        entry.response.statusCode >= 200 && entry.response.statusCode < 300
            ? Icons.public
            : Icons.public_off,
        color:
            entry.response.statusCode >= 200 && entry.response.statusCode < 300
                ? Colors.green
                : Colors.red,
      ),
      title: Text(
        entry.request.method,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: const TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            // TODO: can also display the path
            entry.request.url,
            // Uri.parse(entry.request.url).path,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: const TextStyle(fontSize: 14.0),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              '${entry.timeFormatted} • ${'${entry.asReadableDuration} • ${entry.response.body.toString().asReadableSize}'}',
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: Colors.grey,
      ),
    );
  }
}

class _DatabaseItem extends StatelessWidget {
  final DatabaseLogarteEntry entry;

  const _DatabaseItem({
    Key? key,
    required this.entry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.save_as_rounded,
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.key,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          // const SizedBox(height: 4.0),
          Text(
            entry.value.toString(),
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          '${entry.timeFormatted} • ${entry.source.toString()}',
          style: const TextStyle(
            fontSize: 14.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
