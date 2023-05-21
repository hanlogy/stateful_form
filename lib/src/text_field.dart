import 'package:flutter/widgets.dart';

abstract class StatefulFormTextField<T extends TextEditingController> {
  const StatefulFormTextField({
    required T controller,
  }) : _controller = controller;

  final T _controller;

  /// Text value of current field.
  String get value => _controller.text;

  /// Validates current field.
  ///
  /// Returns an error string to display if the input is invalid, or null
  /// otherwise.
  String? validate() => null;
}
