import 'comparators.dart';
import 'filters.dart';
import 'models.dart';
import 'repositories.dart';

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
