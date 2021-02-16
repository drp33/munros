import 'package:flutter_test/flutter_test.dart';
import 'package:munros/munros.dart';
import 'package:munros/src/interface.dart';

import '../fixtures/repositories.dart';

const munroA = Munro(
  name: 'A',
  heightMeters: 1000,
  category: HillCategory.munro,
  gridReference: '',
);

const munroATop = Munro(
  name: 'A Top',
  heightMeters: 1001,
  category: HillCategory.munroTop,
  gridReference: '',
);

const munroB = Munro(
  name: 'B',
  heightMeters: 1000,
  category: HillCategory.munro,
  gridReference: '',
);

const munroC = Munro(
  name: 'C',
  heightMeters: 800,
  category: HillCategory.munro,
  gridReference: '',
);

const munroD = Munro(
  name: 'D',
  heightMeters: 1200,
  category: HillCategory.munro,
  gridReference: '',
);

const munroE = Munro(
  name: 'E',
  heightMeters: 1200,
  category: HillCategory.munro,
  gridReference: '',
);

Future<void> testExampleQuery(
  WidgetTester tester,
  FakeMunrosRepository repository, {
  int limit,
  List<Munro> resultContainsAllInOrder,
  List<Munro> resultContainsNoneOf,
}) async {
  repository.munros = [
    munroB,
    munroC,
    munroATop,
    munroE,
    munroD,
    munroA,
  ];

  await tester.runAsync(() async {
    final result = await queryMunros(
      repository,
      <MunroSelector>[
        MunroFilter.heightMeters(min: 900),
        MunroFilter.category(HillCategory.munro),
      ],
      <Comparator<Munro>>[
        MunroComparator.heightMetersDescending(),
        MunroComparator.nameAtoZ(),
      ],
      limit,
    );

    expect(result, containsAllInOrder(resultContainsAllInOrder));
    expect(result, isNot(contains(anyElement(resultContainsNoneOf))));
  });
}

void main() {
  group('queryMunros', () {
    FakeMunrosRepository repository;

    setUp(() {
      repository = FakeMunrosRepository();
    });

    // testWidgets required to load from rootBundle.
    testWidgets('should filter, sort', (WidgetTester tester) async {
      await testExampleQuery(
        tester,
        repository,
        resultContainsAllInOrder: [munroD, munroE, munroA, munroB],
        resultContainsNoneOf: [munroATop, munroC],
      );
    });

    testWidgets('should see all results when a high limit is given', (WidgetTester tester) async {
      await testExampleQuery(
        tester,
        repository,
        limit: 100,
        resultContainsAllInOrder: [munroD, munroE, munroA, munroB],
        resultContainsNoneOf: [munroATop, munroC],
      );
    });

    testWidgets('should limit the results', (WidgetTester tester) async {
      await testExampleQuery(
        tester,
        repository,
        limit: 3,
        resultContainsAllInOrder: <Munro>[munroD, munroE, munroA],
        resultContainsNoneOf: [munroATop, munroC, munroB],
      );
    });

    test('should throw an assertion error if the limit is less than 1', () async {
      try {
        await queryMunros(
          repository,
          [MunroFilter.heightMeters(min: 900)],
          [MunroComparator.nameAtoZ()],
          0,
        );
        throw TestFailure('Should have thrown an AssertionError');
      } catch (e) {
        expect(e, isA<AssertionError>());
      }
    });
  });
}
