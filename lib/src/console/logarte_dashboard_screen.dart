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
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(48.0 + 26.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                const TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(
                      icon: Icon(Icons.receipt_long_rounded),
                      text: 'All',
                    ),
                    Tab(
                      icon: Icon(Icons.bug_report_rounded),
                      text: 'Print',
                    ),
                    Tab(
                      icon: Icon(Icons.public),
                      text: 'Network',
                    ),
                    Tab(
                      icon: Icon(Icons.save_as_rounded),
                      text: 'Database',
                    ),
                    Tab(
                      icon: Icon(Icons.radar_rounded),
                      text: 'Navigator',
                    ),
                  ],
                ),
              ],
            ),
          ),
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
        itemBuilder: (context, index) {
          final log = logs.reversed.toList()[index];

          return LogarteEntryItem(log, instance: instance);
        },
        separatorBuilder: (context, index) => const Divider(height: 2.0),
      ),
    );
  }
}
