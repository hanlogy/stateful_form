import 'package:flutter/widgets.dart';

abstract class StatefulFormTextField<T extends TextEditingController> {
  const StatefulFormTextField({
    required this.controller,
  });

  final T controller;

  /// Text value of current field.
  String get value => controller.text;

  /// Validates current field.
  ///
  /// Returns an error string to display if the input is invalid, or null
  /// otherwise.
  String? validate() => null;
}
