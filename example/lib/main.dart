import 'package:flutter/material.dart';

import 'example1/example1.dart';
import 'example2/example2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StatefulForm',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Examples')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Example 1'),
            subtitle: const Text('Simple example'),
            onTap: () {
              _navigateTo(context, const Example1());
            },
          ),
          const Divider(height: 0),
          ListTile(
            title: const Text('Example 2'),
            subtitle: const Text('Work with flutter_bloc'),
            onTap: () {
              _navigateTo(context, const Example2());
            },
          ),
        ],
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => page,
      ),
    );
  }
}
