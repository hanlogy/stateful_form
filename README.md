A Flutter package aims to simplify form validation and state management.

<img src="https://raw.githubusercontent.com/hanlogy/stateful_form/master/doc/example.gif" alt="example" width="425">

## Examples

### Create a StatefulFormTextField

```dart
class UsernameField extends StatefulFormTextField {
  const UsernameField({required super.controller});

  @override
  String? validate() {
    return value.isNotEmpty ? null : 'Username cannot be empty';
  }
}

UsernameField(controller: TextEditingController());
```

### Entire application with StatefulFormBuilder

```dart
import 'package:flutter/material.dart';
import 'package:stateful_form/stateful_form.dart';

class Example extends StatefulWidget {
  const Example({super.key});

  @override
  State<Example> createState() => _ExampleState();
}

class _ExampleState extends State<Example> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _form = StatefulForm();

  @override
  void initState() {
    super.initState();
    _form.fields = [
      UsernameField(controller: _usernameController),
      PasswordField(controller: _passwordController),
    ];
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var count = 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Example')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StatefulFormBuilder(
          form: _form,
          builder: (context, state, child) {
            return Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: state.errorText<UsernameField>(),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: state.errorText<PasswordField>(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_form.validate()) {
                        return;
                      }

                      if (_passwordController.text == '00000000') {
                        _form.setError<PasswordField>('Wrong password');
                        return;
                      }

                      if (count++ == 0) {
                        _form.setError('Something wrong, please try again.');
                        return;
                      }

                      showDialog<void>(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Text('Success'),
                          actions: [CloseButton()],
                        ),
                      );
                    },
                    child: const Text('Login'),
                  ),
                ),
                if (state.errorText() != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    state.errorText()!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                ]
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Creates a username field.
class UsernameField extends StatefulFormTextField {
  const UsernameField({required super.controller});

  @override
  String? validate() {
    return value.isNotEmpty ? null : 'Username cannot be empty';
  }
}

/// Creates a password field.
class PasswordField extends StatefulFormTextField {
  const PasswordField({required super.controller});

  @override
  String? validate() {
    if (value.isEmpty) {
      return 'Password cannot be empty';
    }

    if (value.length > 20) {
      return 'Password is too long';
    }

    if (value.length < 8) {
      return 'Password is too short';
    }

    return null;
  }
}

```
