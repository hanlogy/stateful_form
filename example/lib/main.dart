import 'package:flutter/material.dart';
import 'package:stateful_form/stateful_form.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var count = 0;
    return Scaffold(
      appBar: AppBar(title: const Text('Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StatefulFormBuilder(
          fields: [
            UsernameField(controller: _usernameController),
            PasswordField(controller: _passwordController),
          ],
          builder: (context, delegate) {
            return Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    errorText: delegate.errorText<UsernameField>(),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText: delegate.errorText<PasswordField>(),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (!delegate.validate()) {
                        return;
                      }

                      if (_passwordController.text == '00000000') {
                        delegate.setError<PasswordField>('Wrong password');
                        return;
                      }

                      if (count++ == 0) {
                        delegate.setError('Something wrong, please try again.');
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
                if (delegate.errorText() != null) ...[
                  const SizedBox(height: 10),
                  Text(
                    delegate.errorText()!,
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
