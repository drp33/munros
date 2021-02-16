import 'src/data/hills_db.dart';
import 'src/filters.dart';
import 'src/models.dart';
import 'src/queries.dart';

export 'src/comparators.dart';
export 'src/filters.dart';
export 'src/models.dart';

Future<List<Munro>> getMunros({
  List<MunroSelector> filterBy = const [],
}) {
  assert(filterBy != null);
  final repository = HillsDbLocalRepository();
  return queryMunros(repository, filterBy);
}
