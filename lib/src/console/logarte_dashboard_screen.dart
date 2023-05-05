import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';
import 'package:logarte/src/extensions/string_extensions.dart';

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
              return ListTile(
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
                leading: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(log.response.statusCode.toString()),
                    Icon(
                      log.response.statusCode >= 200 &&
                              log.response.statusCode < 300
                          ? Icons.check_circle
                          : Icons.error,
                      color: log.response.statusCode >= 200 &&
                              log.response.statusCode < 300
                          ? Colors.green
                          : Colors.red,
                    ),
                  ],
                ),
                title: Text(log.request.method),
                subtitle: Text(log.request.url.removeHost),
                trailing: const Icon(Icons.chevron_right),
              );
            } else {
              return const FlutterLogo();
            }
          },
          separatorBuilder: (context, index) => const Divider(height: 0.0),
        ),
      ),
    );
  }
}
