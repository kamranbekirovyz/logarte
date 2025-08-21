import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_entry_item.dart';
import 'package:logarte/src/console/logarte_fab_state.dart';
import 'package:logarte/src/console/logarte_theme_wrapper.dart';

class LogarteDashboardScreen extends StatefulWidget {
  final Logarte instance;
  final bool showBackButton;

  const LogarteDashboardScreen(
    this.instance, {
    Key? key,
    this.showBackButton = false,
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
                  leading: widget.showBackButton
                      ? IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        )
                      : null,
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
                        if (widget.instance.customTab != null)
                          widget.instance.customTab!,
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

class _List<T extends LogarteEntry> extends StatefulWidget {
  const _List({Key? key, required this.instance, required this.search})
      : super(key: key);

  final Logarte instance;
  final String search;

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
    final logs = T == LogarteEntry
        ? widget.instance.logs.value
        : widget.instance.logs.value.whereType<T>().toList();

    final filtered = logs.where((log) {
      return log.contents.any(
        (content) => content.toLowerCase().contains(widget.search),
      );
    }).toList();

    return Scrollbar(
      controller: _scrollController,
      child: ListView.separated(
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: filtered.length,
        padding: const EdgeInsets.only(bottom: 32.0, top: 8.0),
        itemBuilder: (context, index) {
          final log = filtered.reversed.toList()[index];

          return LogarteEntryItem(log, instance: widget.instance);
        },
        separatorBuilder: (context, index) => const Divider(height: 0.0),
      ),
    );
  }
}
