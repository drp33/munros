import 'package:munros/src/core/models.dart';
import 'package:munros/src/core/repositories.dart';

class FakeMunrosRepository implements ReadOnlyMunrosRepository {
  List<Munro> munros;

  @override
  Future<List<Munro>> loadMunros() async => munros;
}
