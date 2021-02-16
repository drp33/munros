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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Munro &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          heightMeters == other.heightMeters &&
          category == other.category &&
          gridReference == other.gridReference);

  @override
  int get hashCode =>
      name.hashCode ^ heightMeters.hashCode ^ category.hashCode ^ gridReference.hashCode;
}

enum HillCategory {
  munro,
  munroTop,
}
