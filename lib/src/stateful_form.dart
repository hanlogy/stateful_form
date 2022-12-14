import 'package:flutter/widgets.dart';

import 'state.dart';
import 'text_field.dart';

/// Creates a [StatefulForm].
class StatefulForm {
  StatefulForm({
    List<StatefulFormTextField> fields = const [],
  }) {
    if (fields.isNotEmpty) {
      this.fields = fields;
    }
  }

  final List<StatefulFormTextField> _fields = [];

  set fields(List<StatefulFormTextField> list) {
    for (final item in list) {
      assert(
        list.where((e) => e.runtimeType == item.runtimeType).length == 1,
        'All StatefulFormTextField must be unique',
      );
    }
    _fields.replaceRange(0, _fields.length, [...list]);
  }

  final _notifier = ValueNotifier<StatefulFormState>(const StatefulFormState());
  final Map<String, String?> _errors = {};

  /// Sets error message for a type [T] field.
  /// It will set as a generic error, if [T] is not given.
  void setError<T extends StatefulFormTextField>(String? text) {
    _errors[T.toString()] = text;
    _emitErrors();
  }

  /// Validates the given [fields]. It will validate all the fields if there is
  /// no given [fields].
  bool validate([List<Type>? fieldTypes]) {
    if (_errors.isNotEmpty) {
      _errors.clear();
      _emitErrors();
    }

    final fields = fieldTypes == null
        ? _fields
        : _fields.where((e) => fieldTypes.contains(e.runtimeType));

    for (final field in fields) {
      final result = field.validate();
      if (result != null) {
        _errors[field.runtimeType.toString()] = result;
      }
    }

    if (_errors.isEmpty) {
      return true;
    }

    _emitErrors();
    return false;
  }

  /// Returns values of all fields.
  Map<Type, String> get value => {
        for (final field in _fields) field.runtimeType: field.value,
      };

  /// Returns the value of the given type [T].
  String valueOf<T>() => _fields.firstWhere((e) => e.runtimeType == T).value;

  void _emitErrors() {
    _notifier.value = _notifier.value.copyWith(errors: {..._errors});
  }

  void dispose() {
    _notifier.dispose();
  }
}

/// Creates a StatefulForm widget.
class StatefulFormBuilder extends ValueListenableBuilder<StatefulFormState> {
  StatefulFormBuilder({
    required StatefulForm form,
    required super.builder,
    super.child,
    super.key,
  }) : super(valueListenable: form._notifier);
}
