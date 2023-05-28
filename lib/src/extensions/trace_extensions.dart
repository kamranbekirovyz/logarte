import 'package:stack_trace/stack_trace.dart';

extension LogarteTraceXs on Trace {
  String? get source {
    return canIncludeSource
        ? '$secondarySourceClass.$secondarySourceMethod'
        : null;
  }

  bool get canIncludeSource {
    return frames.length > 2 &&
        (frames.elementAt(2).member?.contains('.') ?? false);
  }

  String get secondarySourceClass {
    return frames.elementAt(2).member!.split('.').elementAt(0);
  }

  String get secondarySourceMethod {
    return frames.elementAt(2).member!.split('.').elementAt(1);
  }
}
