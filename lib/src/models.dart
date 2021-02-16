import 'package:meta/meta.dart';

class Munro {
  const Munro({
    @required this.name,
    @required this.heightMeters,
    @required this.category,
    @required this.gridReference,
  })  : assert(name != null),
        assert(heightMeters != null),
        assert(category != null),
        assert(gridReference != null);

  /// Name of the hill.
  final String name;

  /// Height in meters.
  final double heightMeters;

  /// Hill category.
  final HillCategory category;

  /// Grid reference.
  final String gridReference;
}

enum HillCategory {
  munro,
  munroTop,
}
