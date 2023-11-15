import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_entry_item.dart';
import 'package:logarte/src/console/logarte_theme_wrapper.dart';

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
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LogarteThemeWrapper(
      child: DefaultTabController(
        length: 5,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  automaticallyImplyLeading: false,
                  title: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: _controller.clear,
                      ),
                    ),
                  ),
                  bottom: const TabBar(
                    isScrollable: true,
                    tabs: [
                      Tab(
                        icon: Icon(Icons.list_alt_rounded),
                        text: 'All',
                      ),
                      Tab(
                        icon: Icon(Icons.bug_report_rounded),
                        text: 'Logs',
                      ),
                      Tab(
                        icon: Icon(Icons.network_check_rounded),
                        text: 'Network',
                      ),
                      Tab(
                        icon: Icon(Icons.storage_rounded),
                        text: 'Storage',
                      ),
                      Tab(
                        icon: Icon(Icons.navigation_rounded),
                        text: 'Router',
                      ),
                    ],
                  ),
                ),
              ];
            },
            // To rebuild the list when the logs list gets modified
            body: ValueListenableBuilder(
              valueListenable: widget.instance.logs,
              builder: (context, values, child) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (_, __) {
                    final search = _controller.text.toLowerCase();

                    return TabBarView(
                      children: [
                        _List<LogarteEntry>(
                          instance: widget.instance,
                          search: search,
                        ),
                        _List<PlainLogarteEntry>(
                          instance: widget.instance,
                          search: search,
                        ),
                        _List<NetworkLogarteEntry>(
                          instance: widget.instance,
                          search: search,
                        ),
                        _List<DatabaseLogarteEntry>(
                          instance: widget.instance,
                          search: search,
                        ),
                        _List<NavigatorLogarteEntry>(
                          instance: widget.instance,
                          search: search,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _List<T extends LogarteEntry> extends StatelessWidget {
  const _List({Key? key, required this.instance, required this.search})
      : super(key: key);

  final Logarte instance;
  final String search;

  @override
  Widget build(BuildContext context) {
    final logs = T == LogarteEntry
        ? instance.logs.value
        : instance.logs.value.whereType<T>().toList();

    final filtered = logs.where((log) {
      return log.contents.any(
        (content) => content.toLowerCase().contains(search),
      );
    }).toList();

    return Scrollbar(
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: filtered.length,
        padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
        itemBuilder: (context, index) {
          final log = filtered.reversed.toList()[index];

          return LogarteEntryItem(log, instance: instance);
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
      ),
    );
  }
}
