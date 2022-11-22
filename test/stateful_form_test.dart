import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/stateful_form.dart';

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
  late StatefulForm form;

  setUp(() {
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    form = StatefulForm(fields: [
      UsernameField(controller: usernameController),
      PasswordField(controller: passwordController),
    ]);
  });

  tearDown(() {
    usernameController.dispose();
    passwordController.dispose();
    form.dispose();
  });

  test('fields must be unique', () {
    expect(() {
      form.fields = [
        UsernameField(controller: usernameController),
        UsernameField(controller: usernameController),
      ];
    }, throwsAssertionError);
  });

  test('value, valueOf', () {
    usernameController.text = 'foo';
    passwordController.text = '000';

    expect(form.value, {UsernameField: 'foo', PasswordField: '000'});
    expect(form.valueOf(UsernameField), 'foo');
    expect(form.valueOf(PasswordField), '000');
  });

  testWidgets('StatefulFormBuilder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulFormBuilder(
            form: form,
            builder: (context, formState, child) {
              return Column(
                children: [
                  TextField(
                    key: const Key('username_input'),
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      errorText: formState.errorText<UsernameField>(),
                    ),
                  ),
                  TextField(
                    key: const Key('password_input'),
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      errorText: formState.errorText<PasswordField>(),
                    ),
                  ),
                  Text(formState.errorText() ?? ''),
                  ElevatedButton(
                    onPressed: () {
                      if (!form.validate()) {
                        return;
                      }
                      showDialog<void>(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('Success!'),
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('username_error'), findsOneWidget);
    expect(find.text('password_error'), findsOneWidget);

    form.setError('other_error');
    await tester.pump();
    expect(find.text('username_error'), findsOneWidget);
    expect(find.text('password_error'), findsOneWidget);
    expect(find.text('other_error'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('username_input')), 'foo');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();
    expect(find.text('username_error'), findsNothing);
    expect(find.text('password_error'), findsOneWidget);
    expect(find.text('Success!'), findsNothing);

    await tester.enterText(find.byKey(const Key('password_input')), '000');
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    expect(find.text('username_error'), findsNothing);
    expect(find.text('password_error'), findsNothing);
    expect(find.text('Success!'), findsOneWidget);
  });
}
