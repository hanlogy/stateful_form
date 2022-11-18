import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/src/state_delegate.dart';
import 'package:stateful_form/src/text_field.dart';

class UsernameField extends StatefulFormTextField {
  UsernameField({required super.controller});

  @override
  String? validate() => value.isEmpty ? 'username_error' : null;
}

class PasswordField extends StatefulFormTextField {
  PasswordField({required super.controller});

  @override
  String? validate() => value.isEmpty ? 'password_error' : null;
}

void main() {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  setUp(() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
  });

  tearDown(() {
    usernameController.dispose();
    passwordController.dispose();
  });

  test('validation and rerendering', () {
    var count = 0;
    StatefulFormStateDelegate? formState;

    formState = StatefulFormStateDelegate(
      fields: [
        UsernameField(controller: usernameController),
        PasswordField(controller: passwordController),
      ],
      rerender: expectAsync0(() {
        formState!;
        switch (count++) {
          case 0:
            expect(formState.errorText<UsernameField>(), 'username_error');
            expect(formState.errorText<PasswordField>(), 'password_error');
            expect(formState.errorText(), null);
            break;
          case 1:
            expect(formState.errorText<UsernameField>(), null);
            expect(formState.errorText<PasswordField>(), null);
            expect(formState.errorText(), null);
            break;
          case 2:
            expect(formState.errorText<UsernameField>(), null);
            expect(formState.errorText<PasswordField>(), 'password_error');
            expect(formState.errorText(), null);
            break;
          case 3:
            expect(formState.errorText<UsernameField>(), null);
            expect(formState.errorText<PasswordField>(), null);
            expect(formState.errorText(), null);
            break;
        }
      }, count: 4),
    );

    expect(count, 0);
    expect(formState.errorText<UsernameField>(), null);
    expect(formState.errorText<PasswordField>(), null);
    expect(formState.errorText(), null);

    expect(formState.validate(), false);

    usernameController.text = 'foo';
    expect(formState.validate(), false);

    passwordController.text = '000';
    expect(formState.validate(), true);
    expect(count, 4);
  });

  test('setError', () {
    var count = 0;
    StatefulFormStateDelegate? formState;

    formState = StatefulFormStateDelegate(
      fields: [
        UsernameField(controller: usernameController),
      ],
      rerender: expectAsync0(() {
        formState!;
        switch (count++) {
          case 0:
            expect(formState.errorText<UsernameField>(), 'username_error');
            expect(formState.errorText(), null);
            break;
          case 1:
            expect(formState.errorText<UsernameField>(), 'username_error');
            expect(formState.errorText(), 'generic_error');
            break;
          case 2:
            expect(formState.errorText<UsernameField>(), null);
            expect(formState.errorText(), null);
            break;
          case 3:
            expect(formState.errorText<UsernameField>(), null);
            expect(formState.errorText(), 'generic_error');
            break;
        }
      }, count: 4),
    );

    expect(formState.validate(), false);
    formState.setError('generic_error');
    usernameController.text = 'foo';
    expect(formState.validate(), true);
    formState.setError('generic_error');
  });
}
