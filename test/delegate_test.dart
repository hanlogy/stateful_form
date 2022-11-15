import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/src/delegate.dart';
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
    StatefulFormDelegate? delegate;

    delegate = StatefulFormDelegate(
      fields: [
        UsernameField(controller: usernameController),
        PasswordField(controller: passwordController),
      ],
      rerender: expectAsync0(() {
        delegate!;
        switch (count++) {
          case 0:
            expect(delegate.errorText<UsernameField>(), 'username_error');
            expect(delegate.errorText<PasswordField>(), 'password_error');
            expect(delegate.errorText(), null);
            break;
          case 1:
            expect(delegate.errorText<UsernameField>(), null);
            expect(delegate.errorText<PasswordField>(), null);
            expect(delegate.errorText(), null);
            break;
          case 2:
            expect(delegate.errorText<UsernameField>(), null);
            expect(delegate.errorText<PasswordField>(), 'password_error');
            expect(delegate.errorText(), null);
            break;
          case 3:
            expect(delegate.errorText<UsernameField>(), null);
            expect(delegate.errorText<PasswordField>(), null);
            expect(delegate.errorText(), null);
            break;
        }
      }, count: 4),
    );

    expect(count, 0);
    expect(delegate.errorText<UsernameField>(), null);
    expect(delegate.errorText<PasswordField>(), null);
    expect(delegate.errorText(), null);

    expect(delegate.validate(), false);

    usernameController.text = 'foo';
    expect(delegate.validate(), false);

    passwordController.text = '000';
    expect(delegate.validate(), true);
    expect(count, 4);
  });

  test('setError', () {
    var count = 0;
    StatefulFormDelegate? delegate;

    delegate = StatefulFormDelegate(
      fields: [
        UsernameField(controller: usernameController),
      ],
      rerender: expectAsync0(() {
        delegate!;
        switch (count++) {
          case 0:
            expect(delegate.errorText<UsernameField>(), 'username_error');
            expect(delegate.errorText(), null);
            break;
          case 1:
            expect(delegate.errorText<UsernameField>(), 'username_error');
            expect(delegate.errorText(), 'generic_error');
            break;
          case 2:
            expect(delegate.errorText<UsernameField>(), null);
            expect(delegate.errorText(), null);
            break;
          case 3:
            expect(delegate.errorText<UsernameField>(), null);
            expect(delegate.errorText(), 'generic_error');
            break;
        }
      }, count: 4),
    );

    expect(delegate.validate(), false);
    delegate.setError('generic_error');
    usernameController.text = 'foo';
    expect(delegate.validate(), true);
    delegate.setError('generic_error');
  });
}
