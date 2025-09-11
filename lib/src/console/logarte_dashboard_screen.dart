import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_entry_item.dart';
import 'package:logarte/src/console/logarte_fab_state.dart';
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
    LogarteFabState.instance.open();
  }

  @override
  void dispose() {
    _controller.dispose();
    LogarteFabState.instance.close();
    super.dispose();
  }

  void _exportAllLogs() {
    final logs = widget.instance.logs.value;
    if (logs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No logs to export')),
      );
      return;
    }

    final export = _generateExportData(logs);
    widget.instance.onExport?.call(export);
  }

  String _generateExportData(List<LogarteEntry> logs) {
    final buffer = StringBuffer();

    // Compact header
    final now = DateTime.now();
    final sessionStart = logs.isNotEmpty ? logs.last.date : now;
    final sessionEnd = logs.isNotEmpty ? logs.first.date : now;

    buffer.writeln('📋 LOGARTE EXPORT');
    buffer.writeln(
        '🕐 ${now.day}/${now.month} session: ${sessionStart.hour}:${sessionStart.minute.toString().padLeft(2, '0')}-${sessionEnd.hour}:${sessionEnd.minute.toString().padLeft(2, '0')}');
    buffer.writeln(
        '📊 ${logs.length} entries (${logs.whereType<PlainLogarteEntry>().length}📝 ${logs.whereType<NetworkLogarteEntry>().length}🌐 ${logs.whereType<DatabaseLogarteEntry>().length}💾 ${logs.whereType<NavigatorLogarteEntry>().length}🧭)');
    buffer.writeln('\n');

    // Export logs in chronological order (reverse order since logs are stored newest first)
    final chronologicalLogs = logs.reversed.toList();

    for (int i = 0; i < chronologicalLogs.length; i++) {
      final entry = chronologicalLogs[i];
      final timestamp =
          '[${entry.date.hour}:${entry.date.minute.toString().padLeft(2, '0')}:${entry.date.second.toString().padLeft(2, '0')}]';

      // Add time separator for gaps > 5 minutes
      if (i > 0) {
        final prevEntry = chronologicalLogs[i - 1];
        final timeDiff = entry.date.difference(prevEntry.date);
        if (timeDiff.inMinutes >= 5) {
          buffer.writeln('⏰ --- ${timeDiff.inMinutes}min gap ---');
        }
      }

      buffer.writeln('$timestamp ${entry.toString()}');
      if (i < chronologicalLogs.length - 1) buffer.writeln();
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return LogarteThemeWrapper(
      child: DefaultTabController(
        length: widget.instance.customTab != null ? 6 : 5,
        child: Scaffold(
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  floating: true,
                  snap: true,
                  leading: BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: [
                    if (widget.instance.onExport != null)
                      IconButton(
                        onPressed: () => _exportAllLogs(),
                        icon: const Icon(Icons.share_rounded),
                        tooltip: 'Export All Logs',
                      ),
                    IconButton(
                      onPressed: () {
                        widget.instance.logs.value = [];
                      },
                      icon: const Icon(Icons.delete_forever_rounded),
                      tooltip: 'Clear All Logs',
                    ),
                    const SizedBox(width: 12),
                  ],
                  bottom: TabBar(
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    labelPadding: const EdgeInsets.symmetric(horizontal: 12.0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Tab(
                        icon: const Icon(Icons.list_alt_rounded),
                        text: 'All (${widget.instance.logs.value.length})',
                      ),
                      Tab(
                        icon: const Icon(Icons.bug_report_rounded),
                        text:
                            'Logging (${widget.instance.logs.value.whereType<PlainLogarteEntry>().length})',
                      ),
                      Tab(
                        icon: const Icon(Icons.public),
                        text:
                            'Network (${widget.instance.logs.value.whereType<NetworkLogarteEntry>().length})',
                      ),
                      Tab(
                        icon: const Icon(Icons.save_as_rounded),
                        text:
                            'Database (${widget.instance.logs.value.whereType<DatabaseLogarteEntry>().length})',
                      ),
                      Tab(
                        icon: const Icon(Icons.navigation_rounded),
                        text:
                            'Navigation (${widget.instance.logs.value.whereType<NavigatorLogarteEntry>().length})',
                      ),
                      if (widget.instance.customTab != null)
                        const Tab(
                          icon: Icon(Icons.extension_rounded),
                          text: 'Custom',
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
                return TabBarView(
                  children: [
                    _List<LogarteEntry>(
                      instance: widget.instance,
                      controller: _controller,
                    ),
                    _List<PlainLogarteEntry>(
                      instance: widget.instance,
                      controller: _controller,
                    ),
                    _List<NetworkLogarteEntry>(
                      instance: widget.instance,
                      controller: _controller,
                    ),
                    _List<DatabaseLogarteEntry>(
                      instance: widget.instance,
                      controller: _controller,
                    ),
                    _List<NavigatorLogarteEntry>(
                      instance: widget.instance,
                      controller: _controller,
                    ),
                    if (widget.instance.customTab != null)
                      widget.instance.customTab!,
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

class _List<T extends LogarteEntry> extends StatefulWidget {
  const _List({
    Key? key,
    required this.instance,
    required this.controller,
  }) : super(key: key);

  final Logarte instance;
  final TextEditingController controller;

  @override
  State<_List<T>> createState() => _ListState<T>();
}

class _ListState<T extends LogarteEntry> extends State<_List<T>> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<LogarteEntry> logs = T == LogarteEntry
        ? widget.instance.logs.value
        : widget.instance.logs.value.whereType<T>().toList();

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (_, __) {
        final String search = widget.controller.text.toLowerCase();
        final List<LogarteEntry> filtered = logs.where((log) {
          return log.contents.any(
            (content) => content.toLowerCase().contains(search),
          );
        }).toList();

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16,
                  left: 16,
                  right: 16,
                  bottom: 8,
                ),
                child: TextField(
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    filled: true,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: widget.controller.clear,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 32, top: 8),
              sliver: SliverList.separated(
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final LogarteEntry entry = filtered[index];

                  return LogarteEntryItem(
                    entry,
                    instance: widget.instance,
                  );
                },
                separatorBuilder: (context, index) {
                  return const Divider(height: 0.0);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
