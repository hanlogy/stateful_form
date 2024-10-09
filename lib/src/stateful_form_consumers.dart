part of 'stateful_form.dart';

class StatefulFormBuilder extends StatefulWidget {
  const StatefulFormBuilder({
    super.key,
    required this.form,
    required this.builder,
  });

  final StatefulForm form;
  final Widget Function(BuildContext context, StatefulFormState state) builder;

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
      child: widget.builder(context, formState),
    );
  }
}

class StatefulFormListener extends StatefulWidget {
  const StatefulFormListener({
    super.key,
    required this.form,
    required this.listener,
    required this.child,
  });

  final StatefulForm form;
  final Widget child;
  final void Function(BuildContext context, StatefulFormState state) listener;

  @override
  State<StatefulFormListener> createState() => _StatefulFormListenerState();
}

class _StatefulFormListenerState extends State<StatefulFormListener> {
  late final _notifier = widget.form._notifier;

  @override
  void initState() {
    super.initState();

    _notifier.addListener(_onStateChanged);
  }

  void _onStateChanged() {
    widget.listener(context, _notifier.value);
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

class StatefulFormConsumer extends StatelessWidget {
  const StatefulFormConsumer({
    super.key,
    required this.form,
    required this.listener,
    required this.builder,
  });

  final StatefulForm form;
  final void Function(BuildContext context, StatefulFormState state) listener;
  final Widget Function(BuildContext context, StatefulFormState state) builder;

  @override
  Widget build(BuildContext context) {
    return StatefulFormListener(
      form: form,
      listener: listener,
      child: StatefulFormBuilder(
        form: form,
        builder: builder,
      ),
    );
  }
}
