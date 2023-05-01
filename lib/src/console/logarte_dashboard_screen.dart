import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';

class LogarteDashboardScreen extends StatelessWidget {
  final Logarte instance;

  const LogarteDashboardScreen(this.instance, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network events, for now.'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          itemCount: instance.logs.length,
          itemBuilder: (context, index) {
            final log = instance.logs.reversed.toList()[index];

            if (log is NetworkLogarteEntry) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NetworkLogEntryDetailsScreen(
                        log,
                        instance: instance,
                      ),
                    ),
                  );
                },
                leading: Text(log.response.statusCode.toString()),
                title: Text(log.request.method),
                subtitle: Text(log.request.url),
                trailing: const Icon(Icons.chevron_right),
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
