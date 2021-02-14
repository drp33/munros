import 'dart:io';

/// Ensures paths resolve in a consistent manner when running tests (otherwise
/// Directory.current behaves differently for `flutter test` and `flutter test test`).
///
/// A fix has been merged for versions >1.22.6 (not yet released to stable channel).
///
/// See https://github.com/flutter/flutter/issues/20907.
void setCurrentDirectoryForTests() {
  if (Directory.current.path.endsWith('${Platform.pathSeparator}test')) {
    Directory.current = Directory.current.parent;
  }
}
