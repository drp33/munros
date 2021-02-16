import 'dart:core';

import '../munros.dart';

class MunroComparator {
  static Comparator<Munro> heightMetersAscending() {
    return (Munro a, Munro b) => a.heightMeters.compareTo(b.heightMeters);
  }

  static Comparator<Munro> heightMetersDescending() {
    return (Munro a, Munro b) => b.heightMeters.compareTo(a.heightMeters);
  }

  static Comparator<Munro> nameAtoZ() {
    return (Munro a, Munro b) => a.name.compareTo(b.name);
  }

  static Comparator<Munro> nameZtoA() {
    return (Munro a, Munro b) => b.name.compareTo(a.name);
  }
}

Comparator<Munro> combineComparators(List<Comparator<Munro>> comparators) {
  if (comparators.isEmpty) {
    return _alwaysZero;
  }

  return comparators.reduce((firstComp, secondComp) => (Munro a, Munro b) {
        final firstOrdering = firstComp(a, b);

        // If equal after the first comparison, try the next.
        return firstOrdering != 0 ? firstOrdering : secondComp(a, b);
      });
}

int _alwaysZero(Munro a, Munro b) => 0;
