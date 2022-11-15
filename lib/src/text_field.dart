import 'package:flutter/widgets.dart';

abstract class StatefulFormTextField {
  const StatefulFormTextField({
    required TextEditingController controller,
  }) : _controller = controller;

  final TextEditingController _controller;

  /// Text value of current field.
  String get value => _controller.text;

  /// Validates current field.
  ///
  /// Returns an error string to display if the input is invalid, or null
  /// otherwise.
  String? validate() => null;
}
