import 'package:munros/src/models.dart';
import 'package:munros/src/repositories.dart';

class FakeMunrosRepository implements ReadOnlyMunrosRepository {
  List<Munro> munros;

  @override
  Future<List<Munro>> loadMunros() async => munros;
}
