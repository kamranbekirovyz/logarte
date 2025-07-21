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
      dense: true,
      onTap: () {
        entry.message.copyToClipboard(context);
      },
      title: Row(
        children: [
          const Icon(
            Icons.bug_report,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              entry.message,
              style: const TextStyle(
                fontSize: 14.0,
              ),
            ),
          ),
        ],
      ),
      subtitle: Text(
        '${entry.timeFormatted} ${entry.source != null ? '• ${entry.source}' : ''}',
        style: const TextStyle(
          fontSize: 12.0,
          color: Colors.grey,
        ),
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
    final action = entry.action;

    return ListTile(
      dense: true,
      title: Row(
        children: [
          Icon(
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
                    : Colors.grey.shade900,
            size: 20.0,
          ),
          const SizedBox(width: 8.0),
          _LuxuryText(
            text: entry.previousRoute != null
                ? entry.action == NavigationAction.pop
                    ? '*$action* from *"${entry.route.routeName}"* to *"${entry.previousRoute.routeName}"*'
                    : '*$action* to *"${entry.route.routeName}"*'
                : '*$action* to *"${entry.route.routeName}"*',
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: Text(
          entry.timeFormatted,
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
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
    final url = Uri.parse(entry.request.url);
    final host = '${url.scheme}://${url.host}';
    final nonHost = entry.request.url.replaceAll(host, '');
    final isSuccess = entry.response.statusCode != null &&
        entry.response.statusCode! >= 200 &&
        entry.response.statusCode! < 300;

    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return NetworkLogEntryDetailsScreen(
                entry,
                instance: instance,
              );
            },
            settings: const RouteSettings(name: '/logarte_entry_details'),
          ),
        );
      },
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 3.0),
            decoration: BoxDecoration(
              color: isSuccess ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Text(
              '${entry.response.statusCode} - ${entry.request.method}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4.0),
          RichText(
              maxLines: 2,
              text: TextSpan(children: [
                TextSpan(
                    text: host,
                    style: const TextStyle(fontSize: 14.0, color: Colors.grey)),
                TextSpan(
                    text: nonHost,
                    style:
                        const TextStyle(fontSize: 14.0, color: Colors.black)),
              ])),
          const SizedBox(height: 4.0),
          Text(
            '${entry.timeFormatted} • ${entry.asReadableDuration} • ${entry.response.body.toString().asReadableSize}',
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
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
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
      onTap: () {
        entry.value?.toString().copyToClipboard(context);
      },
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              Icons.save_as_rounded,
              size: 20.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: _LuxuryText(
              text: '*${entry.target}*: ${entry.value}',
              // style: const TextStyle(
              //   fontSize: 14.0,
              //   fontWeight: FontWeight.w600,
              // ),
            ),
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Text(
          '${entry.timeFormatted} • ${entry.source.toString()}',
          style: const TextStyle(
            fontSize: 12.0,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _LuxuryText extends StatelessWidget {
  final String text;

  const _LuxuryText({required this.text});

  @override
  Widget build(BuildContext context) {
    final List<InlineSpan> children = [];

    final regex = RegExp(r'\*(.*?)\*');
    final matches = regex.allMatches(text);

    int currentIndex = 0;
    for (final match in matches) {
      if (match.start > currentIndex) {
        children.add(
          TextSpan(
            text: text.substring(currentIndex, match.start),
          ),
        );
      }

      children.add(
        TextSpan(
          text: match.group(1),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      );

      currentIndex = match.end;
    }

    if (currentIndex < text.length) {
      children.add(TextSpan(
        text: text.substring(currentIndex),
      ));
    }

    return RichText(
      text: TextSpan(
        children: children,
        style: const TextStyle(
          fontSize: 14.0,
          height: 22 / 14,
          color: Colors.black,
        ),
      ),
    );
  }
}
