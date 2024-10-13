part of 'stateful_form.dart';

typedef StatefulFormListenWhen = bool Function(
    StatefulFormState previous, StatefulFormState current);

typedef StatefulFormBuildWhen = StatefulFormListenWhen;

/// A widget that listens to a [StatefulForm] and rebuilds when the form state
/// changes.
class StatefulFormBuilder extends StatefulWidget {
  const StatefulFormBuilder({
    super.key,
    required this.form,
    required this.builder,
    this.buildWhen,
  });

  final StatefulForm form;
  final Widget Function(BuildContext context, StatefulFormState state) builder;
  final StatefulFormBuildWhen? buildWhen;

  @override
  State<StatefulFormBuilder> createState() => _StatefulFormBuilderState();
}

class _StatefulFormBuilderState extends State<StatefulFormBuilder> {
  late StatefulFormState formState = widget.form._notifier.value;

  @override
  Widget build(BuildContext context) {
    return StatefulFormListener(
      form: widget.form,
      listener: (context, state) {
        setState(() {
          formState = state;
        });
      },
      listenWhen: widget.buildWhen,
      child: widget.builder(context, formState),
    );
  }
}

/// A widget that listens to a [StatefulForm] and calls a callback when the form
/// state changes.
class StatefulFormListener extends StatefulWidget {
  const StatefulFormListener({
    super.key,
    required this.form,
    required this.listener,
    required this.child,
    this.listenWhen,
  });

  final StatefulForm form;
  final Widget child;
  final void Function(BuildContext context, StatefulFormState state) listener;
  final StatefulFormListenWhen? listenWhen;

  @override
  State<StatefulFormListener> createState() => _StatefulFormListenerState();
}

class _StatefulFormListenerState extends State<StatefulFormListener> {
  late final _notifier = widget.form._notifier;
  late StatefulFormState _currentState;
  late StatefulFormState _previousState;

  @override
  void initState() {
    super.initState();

    _currentState = _notifier.value;
    _previousState = _currentState;

    _notifier.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    _currentState = _notifier.value;
    if (widget.listenWhen?.call(_previousState, _currentState) ?? true) {
      widget.listener(context, _currentState);
    }
    _previousState = _currentState;
  }

  @override
  void dispose() {
    _notifier.removeListener(_onStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

/// The combination of [StatefulFormListener] and [StatefulFormBuilder].
class StatefulFormConsumer extends StatelessWidget {
  const StatefulFormConsumer({
    super.key,
    required this.form,
    required this.listener,
    required this.builder,
    this.listenWhen,
    this.buildWhen,
  });

  final StatefulForm form;
  final void Function(BuildContext context, StatefulFormState state) listener;
  final Widget Function(BuildContext context, StatefulFormState state) builder;
  final StatefulFormListenWhen? listenWhen;
  final StatefulFormBuildWhen? buildWhen;

  @override
  Widget build(BuildContext context) {
    return StatefulFormListener(
      form: form,
      listener: listener,
      listenWhen: listenWhen,
      child: StatefulFormBuilder(
        form: form,
        builder: builder,
        buildWhen: buildWhen,
      ),
    );
  }
}

/// A widget that selects a value from a [StatefulForm] and rebuilds when the
/// selected value changes.
class StatefulFormSelector<T> extends StatelessWidget {
  const StatefulFormSelector({
    super.key,
    required this.form,
    required this.selector,
    required this.builder,
  });

  final StatefulForm form;
  final T Function(StatefulFormState state) selector;
  final Widget Function(BuildContext context, T selected) builder;

  @override
  Widget build(BuildContext context) {
    T? selected;

    return StatefulFormBuilder(
      form: form,
      buildWhen: (previous, current) {
        selected = selector(current);
        return selector(previous) != selected;
      },
      builder: (context, formState) {
        return builder(context, selected ?? selector(formState));
      },
    );
  }
}
