part of 'stateful_form.dart';

/// The state of a stateful form.
class StatefulFormState {
  const StatefulFormState({
    Map<String, String?> errors = const {},
  }) : _errors = errors;

  final Map<String, String?> _errors;

  StatefulFormState copyWith({
    Map<String, String?>? errors,
  }) =>
      StatefulFormState(
        errors: errors ?? _errors,
      );

  /// Returns the error text for [T].
  /// It will return a generic error message if [T] is not found.
  String? errorText<T extends StatefulFormTextField>() {
    return _errors[T.toString()];
  }

  @override
  String toString() => jsonEncode({
        'errors': _errors,
      });

  @override
  bool operator ==(Object other) {
    return other is StatefulFormState &&
        runtimeType == other.runtimeType &&
        mapEquals(_errors, other._errors);
  }

  @override
  int get hashCode => _errors.hashCode;
}
