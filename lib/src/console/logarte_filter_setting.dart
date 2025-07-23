import 'package:flutter/material.dart';
import 'package:logarte/logarte.dart';

import '../models/logarte_search_filter.dart';

class LogarteFilterSetting extends StatefulWidget {
  final Logarte logarte;

  const LogarteFilterSetting({super.key, required this.logarte});

  @override
  State<LogarteFilterSetting> createState() => _LogarteFilterSettingState();
}

class _LogarteFilterSettingState extends State<LogarteFilterSetting> {
  late LogarteSearchFilter _searchFilter;

  @override
  void initState() {
    super.initState();
    _searchFilter = widget.logarte.searchFilter.value;
  }

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                      child: Text(
                        'Network Search Filter',
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    LogarteFilterItem(
                      title: 'HTTP Status Code',
                      value: _searchFilter.network.statusCode,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                statusCode: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    LogarteFilterItem(
                      title: 'HTTP Method',
                      value: _searchFilter.network.method,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                method: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    LogarteFilterItem(
                      title: 'URL',
                      value: _searchFilter.network.url,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                url: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    LogarteFilterItem(
                      title: 'Header',
                      value: _searchFilter.network.header,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                header: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    LogarteFilterItem(
                      title: 'Body',
                      value: _searchFilter.network.body,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                body: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    LogarteFilterItem(
                      title: 'Time',
                      value: _searchFilter.network.time,
                      onChanged: (value) {
                        setState(
                          () {
                            _searchFilter = _searchFilter.copyWith(
                              network: _searchFilter.network.copyWith(
                                time: value,
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () {
                          widget.logarte.searchFilter.value = _searchFilter;
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ),
                    // Add bottom padding for safe area
                    const SizedBox(height: 16.0),
                  ],
                ),
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
