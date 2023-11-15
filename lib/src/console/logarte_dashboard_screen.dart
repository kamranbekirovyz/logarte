import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_entry_item.dart';
import 'package:logarte/src/console/logarte_theme_wrapper.dart';

class LogarteDashboardScreen extends StatelessWidget {
  final Logarte instance;

  const LogarteDashboardScreen(
    this.instance, {
    Key? key,
  }) : super(key: key);

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
                    decoration: InputDecoration(
                      hintText: 'Search',
                      filled: true,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          // instance.clear();
                        },
                      ),
                    ),
                    onChanged: (value) {
                      // instance.filter(value);
                    },
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
              valueListenable: instance.logs,
              builder: (context, values, child) {
                return TabBarView(
                  children: [
                    _List<LogarteEntry>(instance: instance),
                    _List<PlainLogarteEntry>(instance: instance),
                    _List<NetworkLogarteEntry>(instance: instance),
                    _List<DatabaseLogarteEntry>(instance: instance),
                    _List<NavigatorLogarteEntry>(instance: instance),
                  ],
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
  const _List({
    Key? key,
    required this.instance,
  }) : super(key: key);

  final Logarte instance;

  @override
  Widget build(BuildContext context) {
    final logs = T == LogarteEntry
        ? instance.logs.value
        : instance.logs.value.where((e) => e.runtimeType == T).toList();

    return Scrollbar(
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: logs.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final log = logs.reversed.toList()[index];

          return LogarteEntryItem(log, instance: instance);
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
      ),
    );
  }
}
