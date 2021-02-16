import 'package:flutter_test/flutter_test.dart';
import 'package:munros/munros.dart';

import '../fixtures/hills_db.dart';

const tallest = benNevis;
const mediumHeight = benVorlichNorthTop;
const shortest = beinnTeallach;

void main() {
  group('MunroComparator', () {
    test('heightMetersAscending', () {
      final munros = <Munro>[tallest, shortest, mediumHeight]
        ..sort(MunroComparator.heightMetersAscending());

      expect(
        munros,
        containsAllInOrder(<Munro>[shortest, mediumHeight, tallest]),
      );
    });

    test('heighMetersDescending', () {
      final munros = <Munro>[tallest, shortest, mediumHeight]
        ..sort(MunroComparator.heightMetersDescending());

      expect(
        munros,
        containsAllInOrder(<Munro>[tallest, mediumHeight, shortest]),
      );
    });

    test('nameAtoZ', () {
      final munros = <Munro>[benVorlichNorthTop, beinnTeallach, benNevis]
        ..sort(MunroComparator.nameAtoZ());

      expect(
        munros,
        containsAllInOrder(<Munro>[beinnTeallach, benNevis, benVorlichNorthTop]),
      );
    });

    test('nameZtoA', () {
      final munros = <Munro>[benVorlichNorthTop, beinnTeallach, benNevis]
        ..sort(MunroComparator.nameZtoA());

      expect(
        munros,
        containsAllInOrder(<Munro>[benVorlichNorthTop, benNevis, beinnTeallach]),
      );
    });
  });

  group('combineComparators', () {
    test('combines multiple comparators into one', () {
      final sameHeightAsMedium = Munro(
        name: 'Mount Doom',
        heightMeters: mediumHeight.heightMeters,
        category: HillCategory.munro,
        gridReference: '',
      );

      final munros = <Munro>[tallest, shortest, mediumHeight, sameHeightAsMedium];

      munros.sort(
        combineComparators([
          MunroComparator.heightMetersAscending(),
          MunroComparator.nameZtoA(),
        ]),
      );

      expect(
        munros,
        containsAllInOrder(<Munro>[shortest, sameHeightAsMedium, mediumHeight, tallest]),
      );
    });

    test('returns an identity comparator if supplied with an empty list', () {
      final list1 = <Munro>[beinnTeallach, benNevis, benVorlichNorthTop];
      final list2 = <Munro>[benVorlichNorthTop, benNevis, beinnTeallach];

      list1.sort(combineComparators([]));
      list2.sort(combineComparators([]));

      expect(list1, containsAllInOrder(list1));
      expect(list2, containsAllInOrder(list2));
    });
  });
}
