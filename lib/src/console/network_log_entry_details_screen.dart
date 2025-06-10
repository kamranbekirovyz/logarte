import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_theme_wrapper.dart';
import 'package:logarte/src/extensions/entry_extensions.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/string_extensions.dart';

enum MenuItem { copy, copyCurl }

class NetworkLogEntryDetailsScreen extends StatelessWidget {
  final NetworkLogarteEntry entry;
  final Logarte instance;

  const NetworkLogEntryDetailsScreen(
    this.entry, {
    Key? key,
    required this.instance,
  }) : super(key: key);

  void handleClick(BuildContext context, MenuItem item) {
    switch (item) {
      case MenuItem.copy:
          final text = entry.toString();
          text.copyToClipboard(context);
        break;
      case MenuItem.copyCurl:
        final cmd = entry.toCurlCommand();
        cmd.copyToClipboard(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LogarteThemeWrapper(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: Navigator.of(context).pop,
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            '${entry.asReadableDuration}, ${entry.response.body.toString().asReadableSize}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          centerTitle: false,
          actions: [
            IconButton(
              tooltip: 'Share',
              icon: const Icon(Icons.share),
              onPressed: () {
                final text = entry.toString();
                instance.onShare?.call(text);
              },
            ),
            PopupMenuButton<MenuItem>(
              tooltip: 'More',
              icon: const Icon(Icons.more_vert),
              onSelected: (item) => handleClick(context, item),
              itemBuilder: (_) => <PopupMenuEntry<MenuItem>>[
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.copy,
                  child: Text('Copy'),
                ),
                const PopupMenuItem<MenuItem>(
                  value: MenuItem.copyCurl,
                  child: Text('Copy as cURL'),
                ),
              ],
            ),
            const SizedBox(width: 12.0),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: [
              const TabBar(
                tabs: [
                  Tab(text: 'Request'),
                  Tab(text: 'Response'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    Scrollbar(
                      child: ListView(
                        children: [
                          SelectableCopiableTile(
                            title: 'METHOD',
                            subtitle: entry.request.method,
                          ),
                          const Divider(height: 0.0),
                          SelectableCopiableTile(
                            title: 'URL',
                            subtitle: entry.request.url,
                          ),
                          const Divider(height: 0.0),
                          SelectableCopiableTile(
                            title: 'HEADERS',
                            subtitle: entry.request.headers.prettyJson,
                          ),
                          if (entry.request.method != 'GET') ...[
                            const Divider(height: 0.0),
                            SelectableCopiableTile(
                              title: 'BODY',
                              subtitle: entry.request.body.prettyJson,
                            ),
                          ],
                        ],
                      ),
                    ),
                    Scrollbar(
                      child: ListView(
                        children: [
                          SelectableCopiableTile(
                            title: 'STATUS CODE',
                            subtitle: entry.response.statusCode.toString(),
                          ),
                          const Divider(height: 0.0),
                          SelectableCopiableTile(
                            title: 'HEADERS',
                            subtitle: entry.response.headers.prettyJson,
                          ),
                          const Divider(height: 0.0),
                          SelectableCopiableTile(
                            title: 'BODY',
                            subtitle: entry.response.body.prettyJson,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectableCopiableTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const SelectableCopiableTile({
    required this.title,
    required this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => _copyToClipboard(context),
      title: SelectableText(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        onTap: () => _copyToClipboard(context),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4.0),
        child: SelectableText(
          subtitle,
          onTap: () => _copyToClipboard(context),
        ),
      ),
      // trailing: const Icon(Icons.copy),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) {
    return subtitle.copyToClipboard(context);
  }
}
