import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

part 'types.dart';
part 'text_field.dart';
part 'state.dart';
part 'stateful_form_consumers.dart';

/// Creates a [StatefulForm].
class StatefulForm {
  StatefulForm({
    List<StatefulFormTextField> fields = const [],
    StatefulFormOnChanged? onChanged,
  }) : _onChanged = onChanged {
    if (fields.isNotEmpty) {
      this.fields = fields;
    }
  }

  final List<StatefulFormTextField> _fields = [];
  StatefulFormOnChanged? _onChanged;

  set fields(List<StatefulFormTextField> list) {
    for (final item in list) {
      assert(
        list.where((e) => e.runtimeType == item.runtimeType).length == 1,
        'All StatefulFormTextField must be unique',
      );
    }
    _fields.replaceRange(0, _fields.length, [...list]);
    list.forEach(_bindListener);
  }

  /// Sets a callback that will be called when any field changes.
  ///
  /// **Warning:** This setter will override the previous one.
  set onChanged(StatefulFormOnChanged onChanged) => _onChanged = onChanged;

  void _addField(StatefulFormTextField field) {
    _fields.add(field);
    _bindListener(field);
  }

  void addField(StatefulFormTextField field) {
    assert(_fields.contains(field) == false, 'Field already exists');

    _addField(field);
  }

  void addFieldIfAbsent(StatefulFormTextField field) {
    if (_fields.contains(field) == false) {
      _addField(field);
    }
  }

  void _bindListener(StatefulFormTextField field) {
    field.controller.addListener(() {
      if (_onChanged != null) {
        _onChanged!(field);
      }
    });
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

    assert(fields.isNotEmpty, 'No fields found');

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
  ///
  /// The type [T] field must be added to the form, otherwise it will return
  /// `null`.
  String? valueOfNullable<T extends StatefulFormTextField>() {
    final fieldIndex = _fields.indexWhere((e) => e.runtimeType == T);
    if (fieldIndex == -1) {
      return null;
    }

    return _fields[fieldIndex].value;
  }

  String valueOf<T extends StatefulFormTextField>() => valueOfNullable<T>()!;

  bool hasField<T extends StatefulFormTextField>() =>
      _fields.any((e) => e.runtimeType == T);

  T fieldOf<T extends StatefulFormTextField>() =>
      _fields.firstWhere((e) => e.runtimeType == T) as T;

  T? fieldOfNullable<T extends StatefulFormTextField>() {
    final fieldIndex = _fields.indexWhere((e) => e.runtimeType == T);
    if (fieldIndex == -1) {
      return null;
    }

    return _fields[fieldIndex] as T;
  }

  void _emitErrors() {
    _notifier.value = _notifier.value.copyWith(errors: {..._errors});
  }

  void dispose() {
    _notifier.dispose();
  }
}
