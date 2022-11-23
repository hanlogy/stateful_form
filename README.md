A Flutter package aims to simplify form validation and state management.

<img src="https://raw.githubusercontent.com/hanlogy/stateful_form/master/doc/example.gif" alt="example" width="425">

## Examples

### Define a StatefulFormTextField

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

### Create a StatefulForm and initialize fields

```dart
final form = StatefulForm(fields: [
  UsernameField(controller: TextEditingController(text: 'username')),
  PasswordField(controller: TextEditingController(text: 'password')),
]);
```

Or

```dart
final form = StatefulForm();

form.fields = [
  UsernameField(controller: TextEditingController(text: 'username')),
  PasswordField(controller: TextEditingController(text: 'password')),
];
```

### Validate

```dart
final newPasswordController = TextEditingController();
final confirmNewPasswordController = TextEditingController();

final form = StatefulForm(fields: [
  NewPasswordField(controller: newPasswordController);
  ConfirmPasswordField(
    controller: confirmNewPasswordController,
    matcher: newPasswordController,
  );
]);

// Validate all fields.
form.validate();

// Validate specific fields.
form.validate([ConfirmPasswordField]);


// Fields definition.
class NewPasswordField extends StatefulFormTextField {
  const NewPasswordField({required super.controller});

  @override
  String? validate() {
    return value.isNotEmpty ? null : 'Please enter new password';
  }
}

class ConfirmPasswordField extends StatefulFormTextField {
  const ConfirmPasswordField({
    required super.controller,
    required this.matcher,
  });

  final TextEditingController matcher;

  @override
  String? validate() {
    if (value.isNotEmpty) {
      return 'Please enter confirm password';
    }

    if (value != matcher.text) {
      return 'Confirm password does not match the new password';
    }

    return null;
  }
}
```

### StatefulFormBuilder and error rendering.

```dart
StatefulFormBuilder(
  form: form,
  builder: (context, formState, child) {
    return Column(
      children: [
        TextField(
          ...
          decoration: InputDecoration(
            errorText: formState.errorText<UsernameField>(),
          ),
        ),
        // Generic error text.
        Text(formState.errorText()??''),
      ],
    );
  },
);
```

### Set error manually

```dart
final form = StatefulForm(fields: [...]);

// Set error for UsernameField.
form.setError<UsernameField>('This username has been taken');

// Set generic error.
form.setError('Our server is crashed');
```

### Other apis.

```dart
// Values of all fields.
form.value

// Value of a given type.
form.valueOf<UsernameField>()
```

### An entire application example.

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
