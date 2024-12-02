import 'package:flutter/foundation.dart' show kDebugMode;

extension Ifdebugging on String {
  String? get ifDebugging => kDebugMode ? this : null;
}
