import 'package:flutter/widgets.dart';

import 'delegate.dart';
import 'text_field.dart';

class StatefulFormBuilder extends StatefulWidget {
  const StatefulFormBuilder({
    super.key,
    required this.builder,
    required this.fields,
  });

  final Widget Function(
    BuildContext context,
    StatefulFormDelegate delegate,
  ) builder;
  final List<StatefulFormTextField> fields;

  @override
  State<StatefulFormBuilder> createState() => _StatefulFormBuilder();
}

class _StatefulFormBuilder extends State<StatefulFormBuilder> {
  late StatefulFormDelegate delegate;

  @override
  void initState() {
    super.initState();
    delegate = StatefulFormDelegate(
      fields: widget.fields,
      rerender: () => setState(() {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, delegate);
  }
}
