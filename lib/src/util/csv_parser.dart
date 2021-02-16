import 'dart:convert';

import 'package:flutter/services.dart';

/// Parses CSV data and returns a [Map] for every line after
/// the header until an empty line (only commas and whitespace) is reached.
///
/// The keys for each map correspond to the values in the header.
Iterable<Map<String, String>> parseCsv(ByteData data) {
  final text = latin1.decode(data.buffer.asUint8List());
  final lines = LineSplitter.split(text).takeWhile(_isNotBlank);
  final rows = lines.map(_extractCommaSeparatedValues);
  final header = rows.first;

  return rows.skip(1).map((row) {
    // If header has a blank value then remove that map entry.
    return Map.fromIterables(header, row)..remove('');
  });
}

bool _isNotBlank(String line) {
  return RegExp(r'[^\s,]+').hasMatch(line);
}

Iterable<String> _extractCommaSeparatedValues(String line) {
  // Adapted from https://stackoverflow.com/questions/1757065/java-splitting-a-comma-separated-string-but-ignoring-commas-in-quotes#answer-1757107
  final unquotedCommaRegex = RegExp(r'\s*,\s*(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)');
  final enclosingQuotationsRegex = RegExp(r'^"|"$');

  // Split on commas, remove outer-most quotes if present.
  return line
      .split(unquotedCommaRegex)
      .map((value) => value.replaceAll(enclosingQuotationsRegex, ''));
}
