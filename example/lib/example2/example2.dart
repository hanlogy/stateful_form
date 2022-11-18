import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:stateful_form/stateful_form.dart';

class Example2 extends StatelessWidget {
  const Example2({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SimpleCubit>(
      create: (context) => SimpleCubit(),
      child: const ExampleView(),
    );
  }
}

class ExampleView extends StatefulWidget {
  const ExampleView({super.key});

  @override
  State<ExampleView> createState() => _ExampleViewState();
}

class _ExampleViewState extends State<ExampleView> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Example 2')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: StatefulFormBuilder(
          fields: [
            NameField(controller: _nameController),
          ],
          builder: (context, formState) {
            return BlocListener<SimpleCubit, String>(
              listener: (context, state) {
                if (state == 'submit') {
                  formState.setError<NameField>('Error');
                }
              },
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      errorText: formState.errorText<NameField>(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20),
                    width: 200,
                    child: ElevatedButton(
                      child: const Text('Save'),
                      onPressed: () {
                        context.read<SimpleCubit>().submit();
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SimpleCubit extends Cubit<String> {
  SimpleCubit() : super('initial');

  void submit() {
    emit('submit');
  }
}

class NameField extends StatefulFormTextField {
  NameField({required super.controller});
}
