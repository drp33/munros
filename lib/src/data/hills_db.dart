import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

import '../models.dart';
import '../repositories.dart';
import '../util/csv_parser.dart';

/// Presents a subset of the fields available from hills-database
///
/// See:
/// * http://www.hills-database.co.uk/
/// * `assets/munrotab_v6.2.csv`
class HdbHillPartial {
  final String name;
  final double heightMeters;
  final String gridRef;
  final HillCategory hillCategoryPost1997;

  HdbHillPartial({
    @required this.name,
    @required this.heightMeters,
    @required this.gridRef,
    @required this.hillCategoryPost1997,
  });

  factory HdbHillPartial.fromMap(Map<String, String> data) {
    return HdbHillPartial(
      name: data['Name'],
      heightMeters: double.tryParse(data['Height (m)']),
      gridRef: data['Grid Ref'],
      hillCategoryPost1997: _hillCategoryMapping[data['Post 1997']],
    );
  }

  static const _hillCategoryMapping = <String, HillCategory>{
    'MUN': HillCategory.munro,
    'TOP': HillCategory.munroTop,
  };

  Munro tryToMunro() {
    if (hillCategoryPost1997 != null) {
      return Munro(
        name: name,
        heightMeters: heightMeters,
        gridReference: gridRef,
        category: hillCategoryPost1997,
      );
    }
    return null;
  }
}

class HillsDbLocalRepository implements ReadOnlyMunrosRepository {
  final String filePath;

  HillsDbLocalRepository([this.filePath = 'packages/munros/assets/munrotab_v6.2.csv']);

  @override
  Future<List<Munro>> loadMunros() async {
    final rawData = await rootBundle.load(filePath);
    return compute(_hillsDbCsvToMunros, rawData, debugLabel: 'Parsing "$filePath".');
  }
}

List<Munro> _hillsDbCsvToMunros(ByteData data) {
  return parseCsv(data)
      .map((cellValues) => HdbHillPartial.fromMap(cellValues))
      .map((hDbMunro) => hDbMunro.tryToMunro())
      .where((munro) => munro != null)
      .toList();
}
