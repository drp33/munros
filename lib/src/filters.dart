import 'models.dart';

/// Signature for functions that select a [Munro].
typedef MunroSelector = bool Function(Munro munro);

/// Factory for filters to use with an [Iterable<Munro>].
abstract class MunroFilter {
  /// Select by height in meters.
  ///
  /// [min] should be greater than or equal to zero.
  /// [max] should be greater than min.
  static MunroSelector heightMeters({double min = 0.0, double max = double.infinity}) {
    assert(min != null);
    assert(max != null);
    assert(min >= 0, 'Min must not be less than 0.');
    assert(min < max, 'Max must be greater than min.');

    return (Munro munro) {
      return min <= munro.heightMeters && munro.heightMeters <= max;
    };
  }

  /// Select by a list of categories.
  ///
  /// If [categories] is empty, no filter will be applied.
  static MunroSelector categories(List<HillCategory> hillCategories) {
    assert(categories != null);

    if (hillCategories.isEmpty) {
      return _alwaysTrue;
    }

    return (Munro munro) => hillCategories.contains(munro.category);
  }

  /// Select by a single category.
  static MunroSelector category(HillCategory hillCategory) {
    assert(hillCategory != null);
    return categories([hillCategory]);
  }
}

MunroSelector combineFilters(Iterable<MunroSelector> filters) {
  return filters.reduce((filterA, filterB) {
    return (Munro munro) => filterA(munro) && filterB(munro);
  });
}

bool _alwaysTrue(Munro munro) => true;
