import 'filters.dart';
import 'models.dart';
import 'repositories.dart';

Future<List<Munro>> queryMunros(
  ReadOnlyMunrosRepository repository,
  List<MunroSelector> filters,
) async {
  final munros = await repository.loadMunros();
  final filter = combineFilters(filters);
  return munros.where(filter).toList();
}
