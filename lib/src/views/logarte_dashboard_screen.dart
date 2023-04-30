import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/views/network_log_entry_details_screen.dart';

class LogarteDashboardScreen extends StatelessWidget {
  const LogarteDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network events, for now.'),
      ),
      body: Scrollbar(
        child: ListView.separated(
          itemCount: Logarte.logs.length,
          itemBuilder: (context, index) {
            final log = Logarte.logs[index];

            if (log is NetworkLogarteEntry) {
              return ListTile(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NetworkLogEntryDetailsScreen(log),
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
