import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';

class LogarteDashboardScreen extends StatefulWidget {
  final Logarte instance;

  const LogarteDashboardScreen(
    this.instance, {
    Key? key,
  }) : super(key: key);

  @override
  State<LogarteDashboardScreen> createState() => _LogarteDashboardScreenState();
}

class _LogarteDashboardScreenState extends State<LogarteDashboardScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72.0),
        child: SafeArea(
          child: Container(
            height: 48.0,
            margin: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 24.0,
            ),
            child: Row(
              children: [
                // TODO: implement dashboard search
                Flexible(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: GestureDetector(
                        onTap: () {},
                        child: const Icon(Icons.clear),
                      ),
                      filled: true,
                      hintText: 'Search..',
                    ),
                  ),
                ),
                // TODO: implement dashboard filter
                // const SizedBox(width: 8.0),
                // IconButton(
                //   onPressed: () {},
                //   icon: Icon(Icons.filter_list),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: Scrollbar(
        child: ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: widget.instance.logs.length,
          itemBuilder: (context, index) {
            final log = widget.instance.logs.reversed.toList()[index];

            if (log is NetworkLogarteEntry) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NetworkLogEntryDetailsScreen(
                        log,
                        instance: widget.instance,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const _Indicator(
                                  label: '🚀',
                                ),
                                const SizedBox(width: 8.0),
                                _Indicator(
                                  label: log.request.method,
                                ),
                                const SizedBox(width: 8.0),
                                _Indicator(
                                  label: log.response.statusCode.toString(),
                                  color: log.response.statusCode >= 200 &&
                                          log.response.statusCode < 300
                                      ? Colors.green.shade100
                                      : Colors.red.shade100,
                                ),
                                if ([
                                  log.response.receivedAt,
                                  log.request.sentAt
                                ].every((e) => e != null)) ...[
                                  const SizedBox(width: 8.0),
                                  _Indicator(
                                    label:
                                        '${log.response.receivedAt!.difference(log.request.sentAt!).inMilliseconds} ms',
                                    uppercase: false,
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 8.0),
                            Text(log.request.url),
                            const SizedBox(height: 4.0),
                            Text(
                              log.timeFormatted,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),
              );
            } else if (log is PlainLogarteEntry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        _Indicator(
                          label: '🐛',
                        ),
                        SizedBox(width: 8.0),
                        _Indicator(
                          label: 'LoginScreen',
                          uppercase: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(log.message),
                    const SizedBox(height: 4.0),
                    Text(
                      log.timeFormatted,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else if (log is DatabaseLogarteEntry) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const _Indicator(
                          label: '🗄️',
                        ),
                        const SizedBox(width: 8.0),
                        _Indicator(
                          label: log.source,
                          uppercase: false,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text('${log.key} => ${log.value.toString()}'),
                    const SizedBox(height: 4.0),
                    Text(
                      log.timeFormatted,
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const FlutterLogo();
            }
          },
          separatorBuilder: (context, index) => const Divider(),
        ),
      ),
    );
  }
}

class _Indicator extends StatelessWidget {
  final String label;
  final Color? color;
  final bool uppercase;

  const _Indicator({
    Key? key,
    required this.label,
    this.color,
    this.uppercase = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.blueGrey.shade100,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        uppercase ? label.toUpperCase() : label,
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}
