import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/string_extensions.dart';

class NetworkLogEntryDetailsScreen extends StatelessWidget {
  final NetworkLogarteEntry entry;
  final Logarte instance;

  const NetworkLogEntryDetailsScreen(
    this.entry, {
    required this.instance,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: repeat request
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.dateFormatted),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            // TODO: implement share
            onPressed: () {
              final text = entry.toString();
              instance.onShare?.call(text);
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy_all),
            onPressed: () {
              final text = entry.toString();
              text.copyToClipboard(context);
            },
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
                        const Divider(),
                        SelectableCopiableTile(
                          title: 'URL',
                          subtitle: entry.request.url,
                        ),
                        const Divider(),
                        SelectableCopiableTile(
                          title: 'HEADERS',
                          subtitle: entry.request.headers.prettyJson,
                        ),
                        const Divider(),
                        SelectableCopiableTile(
                          title: 'BODY',
                          subtitle: entry.request.body.prettyJson,
                        ),
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
                        const Divider(),
                        SelectableCopiableTile(
                          title: 'HEADERS',
                          subtitle: entry.response.headers.prettyJson,
                        ),
                        const Divider(),
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
        onTap: () => _copyToClipboard(context),
      ),
      subtitle: SelectableText(
        subtitle,
        onTap: () => _copyToClipboard(context),
      ),
      // trailing: const Icon(Icons.copy),
    );
  }

  Future<void> _copyToClipboard(BuildContext context) {
    return subtitle.copyToClipboard(context);
  }
}
