import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';
import 'package:logarte/src/console/network_log_entry_details_screen.dart';

class LogarteEntryItem extends StatelessWidget {
  final LogarteEntry entry;
  final Logarte instance;

  const LogarteEntryItem(
    this.entry, {
    Key? key,
    required this.instance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (entry is NetworkLogarteEntry) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NetworkLogEntryDetailsScreen(
                entry as NetworkLogarteEntry,
                instance: instance,
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
                          label: (entry as NetworkLogarteEntry).request.method,
                        ),
                        const SizedBox(width: 8.0),
                        _Indicator(
                          label: (entry as NetworkLogarteEntry)
                              .response
                              .statusCode
                              .toString(),
                          color: (entry as NetworkLogarteEntry)
                                          .response
                                          .statusCode >=
                                      200 &&
                                  (entry as NetworkLogarteEntry)
                                          .response
                                          .statusCode <
                                      300
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                        ),
                        if ([
                          (entry as NetworkLogarteEntry).response.receivedAt,
                          (entry as NetworkLogarteEntry).request.sentAt
                        ].every((e) => e != null)) ...[
                          const SizedBox(width: 8.0),
                          _Indicator(
                            label:
                                '${(entry as NetworkLogarteEntry).response.receivedAt!.difference((entry as NetworkLogarteEntry).request.sentAt!).inMilliseconds} ms',
                            uppercase: false,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text((entry as NetworkLogarteEntry).request.url),
                    const SizedBox(height: 4.0),
                    Text(
                      (entry as NetworkLogarteEntry).timeFormatted,
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
    } else if (entry is PlainLogarteEntry) {
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
                  label: '🐛',
                ),
                const SizedBox(width: 8.0),
                _Indicator(
                  label: (entry as PlainLogarteEntry).source,
                  uppercase: false,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text((entry as PlainLogarteEntry).message),
            const SizedBox(height: 4.0),
            Text(
              (entry as PlainLogarteEntry).timeFormatted,
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    } else if (entry is DatabaseLogarteEntry) {
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
                  label: (entry as DatabaseLogarteEntry).source,
                  uppercase: false,
                ),
              ],
            ),
            const SizedBox(height: 8.0),
            Text(
                '${(entry as DatabaseLogarteEntry).key} = ${(entry as DatabaseLogarteEntry).value.toString()}'),
            const SizedBox(height: 4.0),
            Text(
              (entry as DatabaseLogarteEntry).timeFormatted,
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
  }
}

class _Indicator extends StatelessWidget {
  final String? label;
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
    if (label == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      decoration: BoxDecoration(
        color: color ?? Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        uppercase ? label!.toUpperCase() : label!,
        style: const TextStyle(fontSize: 12.0),
      ),
    );
  }
}
