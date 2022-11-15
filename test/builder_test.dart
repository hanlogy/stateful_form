import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stateful_form/stateful_form.dart';

class UsernameField extends StatefulFormTextField {
  UsernameField({required super.controller});
}

class PasswordField extends StatefulFormTextField {
  PasswordField({required super.controller});
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

  testWidgets('StatefulFormBuilder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatefulFormBuilder(
            fields: [
              UsernameField(controller: usernameController),
              PasswordField(controller: passwordController),
            ],
            builder: (context, delegate) {
              return Column(
                children: [
                  TextField(
                    key: const Key('username_input'),
                    controller: usernameController,
                  ),
                  TextField(
                    key: const Key('password_input'),
                    controller: passwordController,
                  ),
                  ElevatedButton(
                    onPressed: () {
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

    await tester.enterText(find.byKey(const Key('username_input')), 'foo');
    await tester.enterText(find.byKey(const Key('password_input')), '000');
    await tester.tap(find.byType(ElevatedButton));

    await tester.pump();
    expect(find.text('Success!'), findsOneWidget);
  });
}
