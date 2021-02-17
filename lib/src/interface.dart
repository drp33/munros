import 'package:meta/meta.dart';

import 'comparators.dart';
import 'data/hills_db.dart';
import 'filters.dart';
import 'models.dart';
import 'repositories.dart';

/// Returns a list of [Munro]s.
///
/// [filterBy] specifies the conditions on which the [Munro]s are
/// selected. [sortBy] specifies the order in which the results will
/// be returned. The order of the `Comparator`s in this list dictate
/// the order in which they will be applied. [maxResults] limits
/// the number of results that are returned. If null, all matches
/// are returned.
Future<List<Munro>> getMunros({
  List<MunroSelector> filterBy = const [],
  List<Comparator<Munro>> sortBy = const [],
  int maxResults,
}) async {
  assert(filterBy != null);
  assert(sortBy != null);

  final repository = HillsDbLocalRepository();

  return queryMunros(repository, filterBy, sortBy, maxResults);
}

@visibleForTesting
Future<List<Munro>> queryMunros(
  ReadOnlyMunrosRepository repository,
  List<MunroSelector> filters,
  List<Comparator<Munro>> comparators,
  int limit,
) async {
  assert(limit == null || limit > 0);

  final munros = await repository.loadMunros();

  final filter = combineFilters(filters);
  final comparator = combineComparators(comparators);

  final orderedResults = munros.where(filter).toList()..sort(comparator);

  return limit == null ? orderedResults : orderedResults.take(limit).toList();
}
