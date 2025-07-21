import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';

class LogarteFilterSetting extends StatefulWidget {
  final Logarte logarte;

  const LogarteFilterSetting({super.key, required this.logarte});

  @override
  State<LogarteFilterSetting> createState() => _LogarteFilterSettingState();
}

class _LogarteFilterSettingState extends State<LogarteFilterSetting> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12.0),
            width: 40.0,
            height: 4.0,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          // Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: SingleChildScrollView(
                child: ValueListenableBuilder(
                    valueListenable: widget.logarte.searchFilter,
                    builder: (context, value, child) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Text(
                              'Network Search Filter',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          LogarteFilterItem(
                            title: 'Status Code',
                            value: widget
                                .logarte.searchFilter.value.network.statusCode,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  statusCode: value,
                                ),
                              );
                            },
                          ),
                          LogarteFilterItem(
                            title: 'Method',
                            value: widget
                                .logarte.searchFilter.value.network.method,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  method: value,
                                ),
                              );
                            },
                          ),
                          LogarteFilterItem(
                            title: 'URL',
                            value:
                                widget.logarte.searchFilter.value.network.url,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  url: value,
                                ),
                              );
                            },
                          ),
                          LogarteFilterItem(
                            title: 'Header',
                            value: widget
                                .logarte.searchFilter.value.network.header,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  header: value,
                                ),
                              );
                            },
                          ),
                          LogarteFilterItem(
                            title: 'Body',
                            value:
                                widget.logarte.searchFilter.value.network.body,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  body: value,
                                ),
                              );
                            },
                          ),
                          LogarteFilterItem(
                            title: 'Time',
                            value:
                                widget.logarte.searchFilter.value.network.time,
                            onChanged: (value) {
                              widget.logarte.searchFilter.value =
                                  widget.logarte.searchFilter.value.copyWith(
                                network: widget
                                    .logarte.searchFilter.value.network
                                    .copyWith(
                                  time: value,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 8.0),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ),
                          // Add bottom padding for safe area
                          const SizedBox(height: 16.0),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LogarteFilterItem extends StatelessWidget {
  final String title;
  final bool value;
  final Function(bool?) onChanged;

  const LogarteFilterItem({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Padding(
        padding: const EdgeInsets.only(right: 16.0, top: 2.0, bottom: 2.0),
        child: Row(
          children: [
            Checkbox(value: value, onChanged: onChanged),
            Text(title),
          ],
        ),
      ),
    );
  }
}
