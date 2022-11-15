import 'text_field.dart';

class StatefulFormDelegate {
  StatefulFormDelegate({
    required List<StatefulFormTextField> fields,
    required void Function() rerender,
  })  : _rerender = rerender,
        _fields = fields;

  final void Function() _rerender;
  final List<StatefulFormTextField> _fields;
  final _errors = <String, String?>{};

  /// Returns the error message of a field which type is [T].
  /// Returns the generic error, if [T] is not given.
  String? errorText<T extends StatefulFormTextField>() => _errors[T.toString()];

  /// Sets error message for a type [T] field.
  /// It will set as a generic error, if [T] is not given.
  void setError<T extends StatefulFormTextField>(String? text) {
    _errors[T.toString()] = text;
    _rerender();
  }

  /// Validates the given [fields]. It will validate all the fields if there is
  /// no given [fields].
  bool validate([List<StatefulFormTextField>? fields]) {
    if (_errors.isNotEmpty) {
      _errors.clear();
      _rerender();
    }

    for (final field in fields ?? _fields) {
      final result = field.validate();
      if (result != null) {
        _errors[field.runtimeType.toString()] = result;
      }
    }

    final noError = _errors.isEmpty;
    if (!noError) {
      _rerender();
    }

    return noError;
  }
}
