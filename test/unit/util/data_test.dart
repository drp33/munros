import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:munros/src/util/csv_parser.dart';

import '../../helpers.dart';

void main() {
  setCurrentDirectoryForTests();

  group('parseCsv', () {
    test('parses a simple CSV', () async {
      final data = await File('test/data_files/csv/alpha_header_num_values.csv').readAsBytes();

      expect(
        parseCsv(data.buffer.asByteData()),
        containsAllInOrder(<dynamic>[
          {
            'A': '1',
            'B': '2',
            'C': '3',
            'D': '4',
            'E': '5',
          },
          {
            'A': '6',
            'B': '7',
            'C': '8',
            'D': '9',
            'E': '10',
          },
        ]),
      );
    });

    test('parses a CSV with commas inside of quotes', () async {
      final data = await File('test/data_files/csv/abc_duplicates.csv').readAsBytes();

      expect(
        parseCsv(data.buffer.asByteData()),
        containsAll(<dynamic>[
          {
            'A': 'A, A',
            'B': 'B, B',
            'C': 'C, C',
          }
        ]),
      );
    });
  });
}
