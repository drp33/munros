import 'models.dart';

abstract class ReadOnlyMunrosRepository {
  Future<List<Munro>> loadMunros();
}
