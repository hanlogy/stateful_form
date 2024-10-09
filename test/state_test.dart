import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/src/stateful_form.dart';

void main() {
  group('comparison', () {
    test('equal #1', () {
      expect(const StatefulFormState() == const StatefulFormState(), true);
    });

    test('equal #2', () {
      const stateA = StatefulFormState(errors: {'name': 'empty'});
      const stateB = StatefulFormState(errors: {'name': 'empty'});

      expect(stateA == stateB, true);
    });

    test('unequal', () {
      const stateA = StatefulFormState(errors: {'name': 'empty'});
      const stateB = StatefulFormState();

      expect(stateA == stateB, false);
    });
  });

  test('copyWith', () {
    expect(
      const StatefulFormState().copyWith(errors: {'name': 'empty'}),
      const StatefulFormState(errors: {'name': 'empty'}),
    );
  });
}
