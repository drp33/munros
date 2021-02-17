import 'package:flutter_test/flutter_test.dart';
import 'package:munros/src/core/filters.dart';
import 'package:munros/src/core/models.dart';

import '../fixtures/hills_db.dart';

const munro = benNevis;
const munroTop = benVorlichNorthTop;
const shortestMunro = beinnTeallach;

final throwsAssertionError = throwsA(isA<AssertionError>());

void main() {
  group('MunroFilter', () {
    group('.heightMeters', () {
      test('throws if min is less than 0', () {
        expect(() => MunroFilter.heightMeters(min: -1), throwsAssertionError);
      });

      test('throws if max is less min', () {
        expect(() => MunroFilter.heightMeters(max: 10, min: 11), throwsAssertionError);
      });

      test('returns true if the munros height is within the specified range', () {
        final defaultFilter = MunroFilter.heightMeters();
        final specificFilter = MunroFilter.heightMeters(min: 1344, max: 1345);

        expect(defaultFilter(munro), isTrue);
        expect(specificFilter(munro), isTrue);
      });

      test('returns false if the munro height is less than min', () {
        final defaultMaxFilter = MunroFilter.heightMeters(min: 1500);
        final specificFilter = MunroFilter.heightMeters(min: 1500, max: 1600);

        expect(defaultMaxFilter(munro), isFalse);
        expect(specificFilter(munro), isFalse);
      });

      test('returns false if the munro height is greater than max', () {
        final defaultMinFilter = MunroFilter.heightMeters(max: 1100);
        final specificFilter = MunroFilter.heightMeters(min: 1000, max: 1100);

        expect(defaultMinFilter(munro), isFalse);
        expect(specificFilter(munro), isFalse);
      });
    });

    group('.categories', () {
      test('can filter by a subset of categories', () {
        final filter = MunroFilter.categories([HillCategory.munro]);
        expect(filter(munro), isTrue);
        expect(filter(munroTop), isFalse);
      });

      test('can select by multiple categories', () {
        final filter = MunroFilter.categories([HillCategory.munro, HillCategory.munroTop]);
        expect(filter(munro), isTrue);
        expect(filter(munroTop), isTrue);
      });

      test('selects all when no categories are specified', () {
        final filter = MunroFilter.categories([]);
        expect(filter(munro), isTrue);
        expect(filter(munroTop), isTrue);
      });
    });

    group('.category', () {
      test('can select by a single hill category', () {
        final munroFilter = MunroFilter.category(HillCategory.munro);
        final munroTopFilter = MunroFilter.category(HillCategory.munroTop);
        expect(munroFilter(munro), isTrue);
        expect(munroFilter(munroTop), isFalse);
        expect(munroTopFilter(munro), isFalse);
        expect(munroTopFilter(munroTop), isTrue);
      });
    });
  });

  group('combineFilters', () {
    test('should combine multiple filters into one', () {
      final munrofilter = MunroFilter.category(HillCategory.munro);
      final heightFilter = MunroFilter.heightMeters(max: 1000);

      final combined = combineFilters([munrofilter, heightFilter]);

      expect(combined(munro), isFalse); // Too tall.
      expect(combined(munroTop), isFalse); // Wrong category.
      expect(combined(shortestMunro), isTrue);
    });

    test('should return an identity filter if supplied with no filters', () {
      final identity = combineFilters([]);
      expect(identity(munro), isTrue);
      expect(identity(munroTop), isTrue);
      expect(identity(shortestMunro), isTrue);
      expect(identity(null), isTrue);
    });
  });
}
