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
  State<StatefulFormBuilder> createState() => StatefulFormBuilderA();
}

class StatefulFormBuilderA extends State<StatefulFormBuilder> {
  var m = 2;
  late StatefulFormStateDelegate stateDelegate;

  @override
  void initState() {
    super.initState();
    stateDelegate = StatefulFormStateDelegate(
      fields: widget.fields,
      rerender: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, stateDelegate);
  }
}
