import 'package:flutter_test/flutter_test.dart';
import 'package:munros/src/data/hills_db.dart';
import 'package:munros/src/models.dart';

import '../../fixtures/hills_db.dart';

void main() {
  group('HillsDbLocalRepository', () {
    // Widget test required in order to load from rootBundle.
    // TODO: Investigate - test hangs but this is not the case in app. Skipping.
    testWidgets('returns munros from the default hill database csv file', (_) async {
      final repository = HillsDbLocalRepository();
      final munros = await repository.loadMunros();

      // Check some known examples are loaded in.
      expect(
        munros,
        containsAll(<Munro>[
          benNevis,
          benVorlichNorthTop,
          beinnTeallach,
        ]),
      );
    }, skip: true);
  });
}
