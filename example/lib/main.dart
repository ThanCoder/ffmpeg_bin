import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String resultText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Packages')),
      body: SingleChildScrollView(
        child: Container(padding: const .all(10), child: Text(resultText)),
      ),
    );
  }
}
