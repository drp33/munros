import 'core/filters.dart';
import 'core/models.dart';
import 'core/queries.dart';
import 'data/hills_db.dart';

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
