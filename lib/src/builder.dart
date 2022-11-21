import 'package:flutter/widgets.dart';

import 'state_delegate.dart';
import 'text_field.dart';

class StatefulFormBuilder extends StatefulWidget {
  const StatefulFormBuilder({
    super.key,
    required this.builder,
    required this.fields,
    this.builder2,
  });

  final Widget Function(
    BuildContext context,
    StatefulFormStateDelegate formState,
  ) builder;

  final Widget Function(
    BuildContext context,
    StatefulFormStateDelegate formState,
  )? builder2;

  final List<StatefulFormTextField> fields;

  @override
  State<StatefulFormBuilder> createState() => _StatefulFormBuilderState();
}

class _StatefulFormBuilderState extends State<StatefulFormBuilder> {
  late StatefulFormStateDelegate _stateDelegate;

  @override
  void initState() {
    super.initState();
    _stateDelegate = StatefulFormStateDelegate(
      fields: widget.fields,
      rerender: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _stateDelegate);
  }
}
