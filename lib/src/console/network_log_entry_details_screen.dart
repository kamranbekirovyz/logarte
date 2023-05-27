import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/extensions/object_extensions.dart';
import 'package:logarte/src/extensions/string_extensions.dart';

class NetworkLogEntryDetailsScreen extends StatelessWidget {
  final NetworkLogarteEntry entry;
  final Logarte instance;

  const NetworkLogEntryDetailsScreen(
    this.entry, {
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: repeat request
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
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
          // TODO: if all null, hide
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Duration:',
                        ),
                        trailing: Text(
                          '${entry.response.receivedAt!.difference(entry.request.sentAt!).inMilliseconds.toString()} ms',
                        ),
                      ),
                      const Divider(height: 0.0),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text(
                          'Size:',
                        ),
                        trailing: Text(
                          entry.response.body.toString().asReadableSize,
                        ),
                      ),
                    ],
                  ),
                ),
              );
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
                        const Divider(height: 0.0),
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
