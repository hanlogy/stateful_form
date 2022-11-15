import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/stateful_form.dart';

class NameField extends StatefulFormTextField {
  NameField({required super.controller});

  @override
  String? validate() => 'error';
}

void main() {
  test('StatefulFormTextField', () {
    final nameField = NameField(
      controller: TextEditingController(text: 'foo'),
    );

    expect(nameField.value, 'foo');
    expect(nameField.validate(), 'error');
  });
}
