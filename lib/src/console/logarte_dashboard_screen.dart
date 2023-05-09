import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/logarte_entry_item.dart';

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
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: const Size.fromHeight(72.0),
        //   child: SafeArea(
        //     child: Container(
        //       height: 48.0,
        //       margin: const EdgeInsets.only(
        //         left: 16.0,
        //         right: 16.0,
        //         bottom: 24.0,
        //       ),
        //       child: Row(
        //         children: [
        //           // TODO: implement dashboard search
        //           Flexible(
        //             child: TextField(
        //               controller: _searchController,
        //               decoration: InputDecoration(
        //                 prefixIcon: const Icon(Icons.search),
        //                 suffixIcon: GestureDetector(
        //                   onTap: () {},
        //                   child: const Icon(Icons.clear),
        //                 ),
        //                 filled: true,
        //                 hintText: 'Search..',
        //               ),
        //             ),
        //           ),
        //           // TODO: implement dashboard filter
        //           // const SizedBox(width: 8.0),
        //           // IconButton(
        //           //   onPressed: () {},
        //           //   icon: Icon(Icons.filter_list),
        //           // ),
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'All'),
              Tab(text: 'Logs'),
              Tab(text: 'Network'),
              Tab(text: 'Database'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _List<LogarteEntry>(instance: widget.instance),
            _List<PlainLogarteEntry>(instance: widget.instance),
            _List<NetworkLogarteEntry>(instance: widget.instance),
            _List<DatabaseLogarteEntry>(instance: widget.instance),
          ],
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
        ? instance.logs
        : instance.logs.where((e) => e.runtimeType == T).toList();

    return Scrollbar(
      child: ListView.separated(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemCount: logs.length,
        itemBuilder: (context, index) {
          final log = logs.reversed.toList()[index];

          return LogarteEntryItem(log, instance: instance);
        },
        separatorBuilder: (context, index) => const Divider(),
      ),
    );
  }
}
